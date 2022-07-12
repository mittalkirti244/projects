const cds = require('@sap/cds')
const date = require('date-and-time')
cds.env.features.fetch_csrf = true
const validatePhoneNumber = require('validate-phone-number-node-js');
var validator = require("email-validator");

module.exports = cds.service.impl(async function () {
    const {
        MaintenanceRequests,
        RequestTypes,
        RequestStatuses,
        RequestPhases,
        BusinessPartnerVH,
        WorkCenterVH,
        FunctionLocationVH,
        NumberRanges,
        SalesContractVH,
        EquipmentVH,
        Revisions,
        Ranges } = this.entities
    const service1 = await cds.connect.to('NumberRangeService');
    const service2 = await cds.connect.to('alphamasterService');
    const service3 = await cds.connect.to('MAINTREQ_SB');

    var newFormatedDate, tat, reqDeliveryDate, assignedDeliveryDate, vnumberRangeID;
    var queryStatus, queryPhase, query;
    var id1;
    var vplanningPlant, vrevisionText, vworkCenter, vworkCenterPlant, vrevisionStartDate, vrevisionEndDate, vfunctionalLocation, vequipment, reqwcPlant, reqwcDetail
    let cvalue = 1;
    // var vforeCastDays, vforeCastDate, vdiffInCurrentAndArrivalDate, vdiffInArrivalAndDeliveryDate, vdiffInCurrentAndDeliveryDate

    this.on('READ', NumberRanges, req => {
        return service1.tx(req).run(req.query);
    });

    this.on('READ', [BusinessPartnerVH, WorkCenterVH, FunctionLocationVH, SalesContractVH, EquipmentVH, Revisions], req => {
        // try {
        return service2.tx(req).run(req.query);
        /* } catch (error) {
             var vstatusCode = error.statusCode
             var verrorMessage = error.innererror.response.body.error.message.value
             req.error(406, 'Error Code : ' + vstatusCode + ' Error Message : ' + verrorMessage)
         }*/
    });

    //Custom handler for new create(To load details at the time of first CREATE Button i.e., present on list page)
    this.before('NEW', 'MaintenanceRequests', async (req) => {

        //Assigning the current date into all date fields at the time of new create
        req.data.expectedArrivalDate = returnDate(new Date())
        req.data.expectedDeliveryDate = returnDate(new Date())
        req.data.startDate = returnDate(new Date())
        req.data.endDate = returnDate(new Date())
        req.data.to_requestStatus_rStatus = 'Draft'

        req.data.mrCount = cvalue
        console.log('req.data.mrCount', req.data.mrCount + 1)

    });

    this.before('*', 'MaintenanceRequests', async (req) => {
        if (req.data.to_requestPhase_rPhase == 'Initial')
            req.data.criticalityLevel = 2 //orange
        else if (req.data.to_requestPhase_rPhase == 'Planning')
            req.data.criticalityLevel = 3 //green

        if (req.data.to_requestStatus_rStatus == 'Draft')
            req.data.criticalityLevel = 2 //orange
        else if (req.data.to_requestStatus_rStatus == 'Confirmed')
            req.data.criticalityLevel = 3 //green 

        //Date field for Overview page    
        req.data.createdAtDate = returnDate(new Date())
        console.log(' req.data.createdAtDate ', req.data.createdAtDate)

    });

    this.before('CREATE', 'MaintenanceRequests', async (req) => {

        //Fetching the concatenated number from Number range and storing it to request Number of MR
        var query = await SELECT.from(RequestTypes).columns('*').where({ ID: req.data.to_requestType_ID })
        var rTpyeValue = query[0].rType
        req.data.to_requestType_rType = rTpyeValue
        var query1 = await service1.read(NumberRanges)
        for (let i = 0; i < query1.length; i++) {
            if (req.data.to_requestType_rType == query1[i].numberRangeID) {
                const nrID = await service1.getLastRunningNumber(query1[i].numberRangeID)
                req.data.requestNo = nrID
                vnumberRangeID = query1[i].numberRangeID
            }
        }
        //If Request Type is not present in Number Range, it will give Info msg
        //(If selected request type is not there in Number Range, the vnumberRangeID will store undefined)
        console.log('vnumberRangeID...................', vnumberRangeID)
        if (vnumberRangeID == undefined) {
            req.error(406, req.data.to_requestType_rType + ' Type is not present in Number Range.')
        }

        //to auto populate the request status and request phase at the time of create
        /* if (req.data.to_requestStatus_rStatus == 'Confirmed' || req.data.to_requestStatus_rStatus == '') {
             req.data.to_requestStatus_rStatus = 'Draft'
             req.data.to_requestPhase_rPhase = 'Initial'
             req.info(101, 'Request Status should always be Draft when you create a new Maintenance Request')
         }*/

        req.data.to_requestStatus_rStatusDesc = 'Created'
        req.data.to_requestStatus_rStatus = 'CREATED'

        //Insert and update restrictions using hidden criteria
        //To set the request type disable after create
        //And request status to enable after create
        req.data.uiHidden = true
        req.data.uiHidden1 = false
        req.data.requestType1 = req.data.to_requestType_ID
    });

    this.before(['CREATE', 'UPDATE'], 'MaintenanceRequests', async (req) => {

        // vReqStatus = req.data.to_requestStatus_rStatus

        // To make business partner name as readonly field
        let query1 = await service2.read(BusinessPartnerVH).where({ BusinessPartner: req.data.businessPartner })
        if (req.data.businessPartner != null)
            req.data.businessPartnerName = query1[0].BusinessPartnerName

        req.data.bpConcatenation = req.data.businessPartner + '(' + req.data.businessPartnerName + ')'
        console.log('bpConcatenation', req.data.bpConcatenation)

        //To make location WC plant and location detail as readonly field
        let query2 = await service2.read(WorkCenterVH).where({ WorkCenter: req.data.locationWC })
        if (req.data.locationWC != null) {
            req.data.locationWCDetail = query2[0].WorkCenterText
            // req.data.MaintenancePlanningPlant = query2[0].Plant
        }

        //To make functional location name as readonly field
        let q1 = await service2.read(FunctionLocationVH).where({ functionalLocation: req.data.functionalLocation })
        if (req.data.functionalLocation != null)
            req.data.functionalLocationName = q1[0].FunctionalLocationName

        //To make equipment name as readonly field
        let q2 = await service2.read(EquipmentVH).where({ Equipment: req.data.equipment })
        if (req.data.equipment != null)
            req.data.equipmentName = q2[0].EquipmentName

        //Validation for all dates value
        var arrivalDate = req.data.expectedArrivalDate
        var deliveryDate = req.data.expectedDeliveryDate
        // var startDate = req.data.startDate
        // var endDate = req.data.endDate

        if (deliveryDate < arrivalDate)
            // if (deliveryDate < arrivalDate && endDate < startDate)
            return req.error(406, 'Expected Delivery Date should not be less than Expected Arrival Date')
        /* else if (deliveryDate < arrivalDate)
             return req.error(406, 'Expected Delivery Date should not be less than Expected Arrival Date')
         /*else if (endDate < startDate)
             return req.error(406, 'End Date should not be less than Start Date')
         else if (startDate < arrivalDate && endDate < deliveryDate)
             return req.error(406, 'Start Date should not be less than Expected Arrival Date and End Date should not be less than Expected Delivery Date')
         else if (startDate < arrivalDate)
             return req.error(406, 'Start Date should not be less than Expected Arrival Date')
         else if (endDate < deliveryDate)
             return req.error(406, 'End Date should always be greater than Expected Delivery Date')
         else if (deliveryDate < startDate)
             return req.error(406, 'Expected Delivery Date should not be less that Start Date')*/

        //Validation for Phone Number(It starts with (+) operator as optional and should always contains only numbers in it)
        //Phone number should be greater than 7 and validates all valid phone number 
        const phoneCheck = validatePhoneNumber.validate(req.data.ccphoneNumber);
        if (phoneCheck == false && req.data.ccphoneNumber != '')
            req.error(406, 'Please enter a valid Phone Number')

        //Validation for Email Address
        const emailCheck = validator.validate(req.data.ccemail);
        if (emailCheck == false && req.data.ccemail != '')
            req.error(406, 'Please enter a valid E-Mail Address')

        //To fetch the tat and contract name from contract service
        let query3 = await service2.read(SalesContractVH).where({ SalesContract: req.data.contract })
        //var contract = req.data.contract
        //console.log('contract', contract)
        if (req.data.contract != null) {
            // for (let i = 0; i < query3.length; i++) {
            //     if (contract == query3[i].SalesContract) {
            req.data.contractName = query3[0].SalesContractName
            tat = query3[0].TurnAroundTime
            // console.log('tat value :', tat)
            //     }
            // }
        }
        else
            req.data.contractName = ''

        //  if selected contract has tat value then tat + arrival date = delivery date
        //  date.addDays() method of adding days
        if (tat != null) {
            console.log('else if req.data.expectedDeliveryDate', req.data.expectedDeliveryDate)
            var result = new Date(req.data.expectedArrivalDate);
            const value = date.addDays(result, parseInt(tat));
            //console.log('Date after adding days into it', value)
            newFormatedDate = returnDate(value)
            //console.log('newFormatedDate:', newFormatedDate)
        }

        //date logics before and after tat selection (At CREATE time)
        req.data.expectedArrivalDate = returnDate(req.data.expectedArrivalDate)
        req.data.startDate = returnDate(req.data.startDate)

        var newCurrentDate = returnDate(new Date())
        reqDeliveryDate = returnDate(reqDeliveryDate)

        if (req.data.contract == null) {
            req.data.expectedDeliveryDate = returnDate(req.data.expectedDeliveryDate)
            req.data.endDate = returnDate(req.data.endDate)
        }
        else if (tat == '') {
            req.data.expectedDeliveryDate = returnDate(req.data.expectedDeliveryDate)
            req.data.endDate = returnDate(req.data.endDate)
        }
        else if (tat != null) {
            if (req.data.expectedDeliveryDate == newCurrentDate) {
                req.data.expectedDeliveryDate = newFormatedDate
                req.data.endDate = newFormatedDate
            }
            else if (reqDeliveryDate == assignedDeliveryDate) {
                req.data.expectedDeliveryDate = newFormatedDate
                req.data.endDate = newFormatedDate
            }
            else if (reqDeliveryDate != assignedDeliveryDate) {
                req.data.expectedDeliveryDate = reqDeliveryDate
                req.data.endDate = returnDate(req.data.endDate)
            }
        }
        //Storing the before changed expected delivery date 
        assignedDeliveryDate = req.data.expectedDeliveryDate
        console.log('assignedDeliveryDate value : ', assignedDeliveryDate)

        //Assigning BP and BP Name to the fields of BP i.e. present on list page, so that it can filter accordingly
        req.data.businessPartner1 = req.data.businessPartner
        req.data.businessPartnerName1 = req.data.businessPartnerName

        //Details for Bullet micro Chart
        /* req.data.foreCastDate = calculateForeCastDate(req.data.expectedDeliveryDate)
         req.data.diffInCurrentAndArrivalDate = calculateDiffInCurrentAndArrivalDate(req.data.expectedArrivalDate)
         req.data.diffInCurrentAndDeliveryDate = calculateDiffInCurrentAndDeliveryDate(req.data.expectedDeliveryDate)
         req.data.diffInDeliveryAndArrivalDate = calculateDiffInDeliveryAndArrivalDate(req.data.expectedDeliveryDate, req.data.expectedArrivalDate)
         req.data.foreCastDaysValue = req.data.diffInDeliveryAndArrivalDate + 10
 
         console.log('req.data.foreCastDays', req.data.foreCastDays)
         console.log('req.data.foreCastDate', req.data.foreCastDate)
         console.log('req.data.diffInCurrentAndArrivalDate', req.data.diffInCurrentAndArrivalDate)
         console.log('req.data.diffInDeliveryAndArrivalDate', req.data.diffInDeliveryAndArrivalDate)*/

        req.data.startDate = req.data.expectedArrivalDate
        req.data.endDate = req.data.expectedDeliveryDate

        req.data.requestNoConcat = req.data.requestNo

        //STatus and Phase value for list report page 
        req.data.to_requestStatus1_rStatus = req.data.to_requestStatus_rStatus
        req.data.to_requestStatus1_rStatusDesc = req.data.to_requestStatus_rStatusDesc



    });

    /*this.before('UPDATE', 'MaintenanceRequests', async (req) => {

        // the request phase will change after selecting request status from edit screen
        if (req.data.to_requestStatus_rStatus == 'Confirmed') {
            req.data.to_requestPhase_rPhase = 'Planning'
        }
    });*/

    this.after('PATCH', 'MaintenanceRequests', async (req) => {
        //Fetch delivery date whenever user select the field at UI
        reqDeliveryDate = req.expectedDeliveryDate
        //console.log('Value of selectedDeliveryDate: ', reqDeliveryDate)
    });

    /*this.on('requestMail', async (req) => {
        for (let i = 0; i < req.params.length; i++) {
            const id1 = req.params[i].ID
            const tx1 = cds.transaction(req)

            var query = await tx1.read(MaintenanceRequests).where({ ID: id1 })
            //console.log('query.........', query[i].to_botStatus_ID)

            // if (query[i].MaintenanceRevision != null && query[i].to_botStatus_ID != 1) {
            if (query[i].to_botStatus_ID != 1) {
                req.info(101, 'Request for E-Mail sent.')

                const affectedRows = await UPDATE(MaintenanceRequests).set({
                    to_botStatus_ID: 1,
                    to_botStatus_bStatus: 'E-Mail Requested'
                }).where({ ID: query[i].ID })
            }
            // else {
            //  if (query[i].MaintenanceRevision == null && query[i].to_botStatus_ID == 1) {
            //      req.error(406, 'E-Mail cannot be sent, as Revision is not created for Maintenance Request ' + query[i].requestNo)
            //  }
            //  // else if (query[i].MaintenanceRevision == null) {
            //    //  req.error(406, 'E-Mail cannot be sent, as Revision is not created for Maintenance Request ' + query[i].requestNo)
            //  } 
            else if (query[i].to_botStatus_ID == 1) {
                req.error(406, 'E-Mail already sent for Maintenance Request ' + query[i].requestNo)
            }
            // }
        }
    });*/

    this.on('changeStatus', async (req) => {
        id1 = req.params[0].ID
        console.log('id1', id1)
        const tx1 = cds.transaction(req)
        query = await tx1.read(MaintenanceRequests).where({ ID: id1 })
        console.log('query................', query)
        queryStatus = await tx1.read(RequestStatuses).where({ rStatusDesc: req.data.status })
        console.log('query Status...............', queryStatus)
        queryPhase = await tx1.read(RequestPhases).where({ rPhase: queryStatus[0].to_rPhase_rPhase })
        console.log('query pahse', queryPhase)

        if (query[0].to_requestStatus_rStatus == 'CREATED' && queryStatus[0].rStatus == 'REQFORWL')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'CREATED' && queryStatus[0].rStatus != 'REQFORWL')
            req.info(101, 'Request Status is at Created State and can move only to Request for Work List State for Maintenance Request '+  query[0].requestNoConcat)

        else if (query[0].to_requestStatus_rStatus == 'REQFORWL' && queryStatus[0].rStatus == 'REQWL')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'REQFORWL' && queryStatus[0].rStatus != 'REQWL')
            req.info(101, 'Request Status is at Request for Work List State and can move only to Requested Work List State for Maintenance Request '+  query[0].requestNoConcat)

        else if (query[0].to_requestStatus_rStatus == 'REQWL' && queryStatus[0].rStatus == 'RECEIVEDNEWWL')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'REQWL' && queryStatus[0].rStatus != 'RECEIVEDNEWWL')
            req.info(101, 'Request Status is at Requested Work List State and can only move to Received New Work List State for Maintenance Request '+  query[0].requestNoConcat)

        else if (query[0].to_requestStatus_rStatus == 'RECEIVEDNEWWL' && queryStatus[0].rStatus == 'SCREENNEWWL')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'RECEIVEDNEWWL' && queryStatus[0].rStatus != 'SCREENNEWWL')
            req.info(101, 'Request Status is at Received New Work List State and can only move to Screen New Work List State for Maintenance Request '+  query[0].requestNoConcat)

        else if (query[0].to_requestStatus_rStatus == 'SCREENNEWWL' && (queryStatus[0].rStatus == 'VALIDATEDWL' || queryStatus[0].rStatus == 'REQWL'))
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'SCREENNEWWL' && (queryStatus[0].rStatus != 'VALIDATEDWL' || queryStatus[0].rStatus != 'REQWL'))
            req.info(101, 'Request Status is at Screen New Work List State and can only move to Validated Work List or Requested Work List state for Maintenance Request '+  query[0].requestNoConcat)

        else if (query[0].to_requestStatus_rStatus == 'VALIDATEDWL' && queryStatus[0].rStatus == 'CREATEDWL')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'VALIDATEDWL' && queryStatus[0].rStatus != 'CREATEDWL')
            req.info(101, 'Request Status is at Validated Work List State and can only move to Created Work List State for Maintenance Request '+  query[0].requestNoConcat)

        else if (query[0].to_requestStatus_rStatus == 'CREATEDWL' && queryStatus[0].rStatus == 'RECEIVEDALWL')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'CREATEDWL' && queryStatus[0].rStatus != 'RECEIVEDALWL')
            req.info(101, 'Request Status is at Created Work List State and can only move to Received All Work List state for Maintenance Request '+  query[0].requestNoConcat)

        else if (query[0].to_requestStatus_rStatus == 'RECEIVEDALWL' && (queryStatus[0].rStatus == 'READYFORAPPROVAL' || queryStatus[0].rStatus == 'REQWL'))
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'RECEIVEDALWL' && (queryStatus[0].rStatus != 'READYFORAPPROVAL' || queryStatus[0].rStatus != 'REQWL'))
            req.info(101, 'Request Status is at Received All Work List State and can only move to Ready for Approval or Requested Work List for Maintenance Request '+  query[0].requestNoConcat)

        else if (query[0].to_requestStatus_rStatus == 'READYFORAPPROVAL' && queryStatus[0].rStatus == 'APPROVEDMR')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'READYFORAPPROVAL' && queryStatus[0].rStatus != 'APPROVEDMR')
            req.info(101, 'Request Status is at Ready for Approval State and can only move to Approved Maintenance Request for Maintenance Request '+  query[0].requestNoConcat)

        else if (query[0].to_requestStatus_rStatus == 'APPROVEDMR' && queryStatus[0].rStatus == 'UPDATEDTL')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'APPROVEDMR' && queryStatus[0].rStatus != 'UPDATEDTL')
            req.info(101, 'Request Status is at Approved Maintenance Request State and can only move to Updated Task List state for Maintenance Request '+  query[0].requestNoConcat)

        /* else if (query[0].to_requestStatus_rStatus == 'UPDATEDTL' && queryStatus[0].rStatus == 'UPDATEDTL')
             updateStatus()*/
        else if (query[0].to_requestStatus_rStatus == 'UPDATEDTL' && queryStatus[0].rStatus != 'UPDATEDTL')
            req.info(101, 'Request Status is at Updated Task List  State and now you can create a revision for Maintenance Request '+  query[0].requestNoConcat)

        else if (query[0].to_requestStatus_rStatus == 'CREATEDREVISION' && queryStatus[0].rStatus == 'CREATEDNOTIF')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'CREATEDREVISION' && queryStatus[0].rStatus != 'CREATEDNOTIF')
            req.info(101, 'Request Status is at Created Revision State and can only move to Created Notification state for Maintenance Request '+  query[0].requestNoConcat)

        else if (query[0].to_requestStatus_rStatus == 'CREATEDNOTIF' && queryStatus[0].rStatus == 'COMPLETEDMR')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'CREATEDNOTIF' && queryStatus[0].rStatus != 'COMPLETEDMR')
            req.info(101, 'Request Status is at Created Notification State and can only move to Completed Maintenance Request state for Maintenance Request '+  query[0].requestNoConcat)

        else if (query[0].to_requestStatus_rStatus == 'COMPLETEDMR' && queryStatus[0].rStatus != 'COMPLETEDMR')
            req.info(101, 'Maintenace Request is already Completed for Maintenance Request '+  query[0].requestNoConcat)
    })

    async function updateStatus() {
        await UPDATE(MaintenanceRequests).set({
            to_requestStatus_rStatus: queryStatus[0].rStatus,
            to_requestStatus1_rStatus: queryStatus[0].rStatus,
            to_requestStatus_rStatusDesc: queryStatus[0].rStatusDesc,
            to_requestStatus1_rStatusDesc: queryStatus[0].rStatusDesc,
            to_requestPhase_rPhase: queryPhase[0].rPhase,
            to_requestPhase_rPhaseDesc: queryPhase[0].rPhaseDesc
        }).where({ ID: id1 })
    }

    this.on('revisionCreated', async (req) => {
        // for (let i = 0; i < req.params.length; i++) {
        const id1 = req.params[0].ID
        const tx1 = cds.transaction(req)
        var queryStatus = await tx1.read(RequestStatuses).where({ rStatusDesc: 'Created Revision' })
        console.log('query', queryStatus)
        var queryPhase = await tx1.read(RequestPhases).where({ rPhaseDesc: 'Preparation' })
        console.log('query', queryPhase)
        var query = await tx1.read(MaintenanceRequests).where({ ID: id1 })
        console.log('query...........', query)

        if (query[0].to_requestStatus_rStatus == 'UPDATEDTL') {

            //Fetching planning plant, request desc, work center and arrival and delivery date for performing POST request to MaintRevision S4 Service
            //Mandatory fields for creating a revision
            if (reqwcPlant == null) {
                vplanningPlant = query[0].MaintenancePlanningPlant
            }
            else {
                vplanningPlant = reqwcPlant
            }
            //Revision text will contain Request description + request Number
            vrevisionText = query[0].requestNo + ' ' + query[0].requestDesc
            vworkCenter = query[0].locationWC

            //After selecting thw workcenter that is coming from patch
            //supose user refresh the screen then plant will get removed -> if else condition is used to resolve this issue
            if (reqwcPlant == null) {
                vworkCenterPlant = query[0].MaintenancePlanningPlant
            }
            else {
                vworkCenterPlant = reqwcPlant
            }
            /* /Date(1224043200000)/ */
            var vexpectedArrivalDate = new Date(query[0].expectedArrivalDate)
            var vformatexpectedArrivalDate = '/Date(' + vexpectedArrivalDate.getTime() + ')/'
            //console.log('vformatexpectedArrivalDate', vformatexpectedArrivalDate)
            vrevisionStartDate = query[0].expectedArrivalDate
            var vexpectedDeliveryDate = new Date(query[0].expectedDeliveryDate)
            var vformatedexpectedDeliveryDate = '/Date(' + vexpectedDeliveryDate.getTime() + ')/'
            // console.log('vformatedexpectedDeliveryDate', vformatedexpectedDeliveryDate)
            vrevisionEndDate = query[0].expectedDeliveryDate
            vfunctionalLocation = query[0].functionalLocation
            vequipment = query[0].equipment

            //Revision will trigger when requestphase will change from intial to planning
            // if (query[0].to_requestPhase_rPhase == 'Planning') {
            //One request should always have 1 MR
            if (query[0].MaintenanceRevision == null) {
                try {
                    if (vplanningPlant != null && vrevisionText != null && vworkCenter != null && vworkCenterPlant != null && vrevisionStartDate != null && vrevisionEndDate != null) {
                        const tx = service3.tx(req)
                        var data = {
                            "PlanningPlant": vplanningPlant,
                            "RevisionType": 'A1',
                            "RevisionText": vrevisionText,
                            "WorkCenter": vworkCenter,
                            "WorkCenterPlant": vworkCenterPlant,
                            "RevisionStartDate": vformatexpectedArrivalDate,
                            "RevisionStartTime": 'PT00H00M00S',
                            "RevisionEndDate": vformatedexpectedDeliveryDate,
                            "RevisionEndTime": 'PT00H00M00S'
                        }
                        if (vfunctionalLocation == null && vequipment == null) {
                            var result = await tx.send({ method: 'POST', path: 'MaintRevision', data })
                        }
                        else if (vequipment != null && vfunctionalLocation == null) {
                            var data1 = Object.create(data)
                            data.Equipment = vequipment
                            var result = await tx.send({ method: 'POST', path: 'MaintRevision', data })
                        }
                        else if (vfunctionalLocation != null && vequipment == null) {
                            var data1 = Object.create(data)
                            data.FunctionLocation = vfunctionalLocation
                            var result = await tx.send({ method: 'POST', path: 'MaintRevision', data })
                        }
                        //If user selects both floc and equipment
                        else if (vfunctionalLocation != null && vequipment != null) {
                            //If there is a parent-child relationship then try block runs
                            //Function Location - A350-MSN-AA-31      
                            //Equipment - 10000095
                            try {
                                var data1 = Object.create(data)
                                data.FunctionLocation = vfunctionalLocation
                                data.Equipment = vequipment
                                var result = await tx.send({ method: 'POST', path: 'MaintRevision', data })
                            } catch (error) {
                                //If floc and equip are not in parent-child relation then floc will pass to create a revision
                                var data1 = Object.create(data)
                                data.FunctionLocation = FunctionLocation
                                var result = await tx.send({ method: 'POST', path: 'MaintRevision', data })
                            }
                        }
                        console.log('Revision', result)
                        const affectedRows = await UPDATE(MaintenanceRequests).set({
                            MaintenanceRevision: result.RevisionNo,
                            revisionType: result.RevisionType,
                            revisionText: result.RevisionText,
                            to_requestStatus_rStatus: 'CREATEDREVISION',
                            to_requestStatus1_rStatus: 'CREATEDREVISION',
                            to_requestStatus_rStatusDesc: 'Created Revision',
                            to_requestStatus1_rStatusDesc: 'Created Revision',
                            to_requestPhase_rPhase: 'PREPARATION',
                            to_requestPhase_rPhaseDesc: 'Preparation'
                        }).where({ ID: id1 })
                        req.info(101, 'Revision ' + result.RevisionNo + ' created for Maintenance Request ' + query[0].requestNoConcat)
                        // query[0].to_requestStatus_rStatus = 'Revision Created'
                        return result
                        /* const { result1 } = await this.transaction(req).run(await tx.send({ method: 'POST', path: 'MaintRevision', data }))
                        // await tx.run(req.query);
                         req.on('succeeded', () => {
                             console.log('abc ------------------------')
                         })
                         console.log('result1....value..........', result1)*/
                    }
                    /* else
                         req.error(406, 'Work center is required to create a revision')*/
                }
                catch (error) {
                    var vstatusCode = error.statusCode
                    var verrorMessage = error.innererror.response.body.error.message.value
                    req.error(406, 'Error Code : ' + vstatusCode + ' Error Message : ' + verrorMessage)
                }
            }
           /* else if (query[0].MaintenanceRevision != null && query[0].to_requestStatus_rStatus == 'CREATEDREVISION') {
                req.data.to_requestStatus_rStatus = 'CREATEDREVISION'
                req.info(101, 'Revision is already been created for this Maintenance Request')
            }*/
        }
        else if (query[0].to_requestStatus_rStatus == 'CREATEDNOTIF' || query[0].to_requestStatus_rStatus == 'COMPLETEDMR' || query[0].to_requestStatus_rStatus == 'CREATEDREVISION'){
            req.data.to_requestStatus_rStatus = 'CREATEDREVISION'
            req.info(101, 'Revision is already been created for this Maintenance Request ' + query[0].requestNoConcat)

        } 
        else if (query[0].to_requestStatus_rStatus != 'CREATEDNOTIF' || query[0].to_requestStatus_rStatus != 'COMPLETEDMR' || query[0].to_requestStatus_rStatus != 'UPDATEDTL')
            req.info(101, 'Task List should be updated before creating Revision for this Maintenance Request ' + query[0].requestNoConcat)
        //}
    })

    this.on('calculateAgingFunc', async (req) => {
        var query = await SELECT.from(MaintenanceRequests).columns('*')
        var query1 = await SELECT.from(Ranges).columns('*')
        console.log('query', query)
        console.log('query1', query1)
        for (let i = 0; i < query.length; i++) {

            var rangeID, range, age;

            var currentDate = new Date()
            //var currentDate = new Date("2023-07-11T10:44:42.709Z");
            var createdDate = new Date(query[i].createdAt);

            console.log('createdDate', createdDate)
            console.log('currentDate', currentDate)
            console.log('age', query[i].age)

            var Difference_In_Time = currentDate.getTime() - createdDate.getTime()
            console.log('Difference_In_Time', Difference_In_Time)
            //To find the difference between the days i.e age
            var Difference_In_Days = Math.round(Difference_In_Time / (1000 * 3600 * 24)); //1000 * 3600 * 24 is no of seconds in a day
            console.log('Difference_In_Days', Difference_In_Days)

            age = Difference_In_Days;

            //To assign range for the record
            if (age == 30 || age < 30) {
                rangeID = query1[0].ID;
                range = query1[0].range;
            } else if (age == 60 || age > 30 && age < 60) {
                rangeID = query1[1].ID;
                range = query1[1].range;
            } else if (age == 90 || age > 60 && age < 90) {
                rangeID = query1[2].ID;
                range = query1[2].range;
            } else if (age == 120 || age > 90 && age < 120) {
                rangeID = query1[3].ID;
                range = query1[3].range;
            } else if (age == 150 || age > 120 && age < 150) {
                rangeID = query1[4].ID;
                range = query1[4].range;
            } else if (age == 180 || age > 150 && age < 180) {
                rangeID = query1[5].ID;
                range = query1[5].range;
            } else if (age == 210 || age > 180 && age < 210) {
                rangeID = query1[6].ID;
                range = query1[6].range;
            } else if (age == 240 || age > 210 && age < 240) {
                rangeID = query1[7].ID;
                range = query1[7].range;
            } else if (age == 270 || age > 240 && age < 270) {
                rangeID = query1[8].ID;
                range = query1[8].range;
            } else if (age > 270) {
                rangeID = query1[9].ID;
                range = query1[9].range;
            }

            await UPDATE(MaintenanceRequests).set({
                age: Difference_In_Days,
                to_ranges_ID: rangeID,
                to_ranges_range: range
            }).where({ ID: query[i].ID });
            console.log('newAge', Difference_In_Days)
            console.log('range', range)
        }
        return "Aging Calculated";
    })

    this.on('calculateAging', async (req) => {
        this.calculateAgingFunc();
    })

    //Function for converting date into (YYYY-MM-DD) format
    function returnDate(dateValue) {
        var newDate = new Date(dateValue)
        var vdate = newDate.getDate();
        if (vdate.toString().length == 1) {
            vdate = '0' + vdate
        }
        var vmonth = newDate.getMonth() + 1
        if (vmonth.toString().length == 1) {
            vmonth = '0' + vmonth
        }
        var vyear = newDate.getFullYear()
        var result = String(vyear) + '-' + String(vmonth) + '-' + String(vdate)
        return result
    }
})