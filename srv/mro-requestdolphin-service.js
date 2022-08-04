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
        RevisionVH,
        Documents,
        DocumentStatuses,
        Ranges,
        MaintenanceRequestHeader } = this.entities
    const service1 = await cds.connect.to('NumberRangeService');
    const service2 = await cds.connect.to('alphamasterService');
    const service3 = await cds.connect.to('MAINTREQ_SB');
    const service4 = await cds.connect.to('notifleo');

    var newFormatedDate, tat, reqDeliveryDate, assignedDeliveryDate, vnumberRangeID;
    var queryStatus, queryPhase, query;
    var id1;
    var vplanningPlant, vrevisionText, vworkCenter, vworkCenterPlant, vrevisionStartDate, vrevisionEndDate, vfunctionalLocation, vequipment, reqwcPlant, reqwcDetail
    let cvalue = 1;
    // var vforeCastDays, vforeCastDate, vdiffInCurrentAndArrivalDate, vdiffInArrivalAndDeliveryDate, vdiffInCurrentAndDeliveryDate

    //Read the NumberRanges entity from Number Range Service
    this.on('READ', NumberRanges, req => {
        return service1.tx(req).run(req.query);
    });

    //Read the BusinessPartnerVH, WorkCenterVH, FunctionLocationVH, SalesContractVH, EquipmentVH, Revisions entity from S4(MaintReq).
    this.on('READ', [BusinessPartnerVH, WorkCenterVH, FunctionLocationVH, SalesContractVH, EquipmentVH, RevisionVH], req => {
        return service2.tx(req).run(req.query);
    });

    //Read the MaintenanceRequestHeader from WorkItem Service
    this.on('READ', MaintenanceRequestHeader, req => {
        return service4.tx(req).run(req.query);
    });

    //Custom handler for new create(To load details at the time of first CREATE Button i.e., present on list page)
    this.before('NEW', 'MaintenanceRequests', async (req) => {

        //Assigning the current date into all date fields at the time of new create
        req.data.expectedArrivalDate = returnDate(new Date())
        req.data.expectedDeliveryDate = returnDate(new Date())
        req.data.startDate = returnDate(new Date())
        req.data.endDate = returnDate(new Date())
        req.data.createdAtDate = returnDate(new Date())

        req.data.mrCount = cvalue
        console.log('req.data.mrCount', req.data.mrCount + 1)
    });

    //This handler is used while creating a record(Create Handler)
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

        //Field to be field at the time of creating a new record
        req.data.to_requestStatus_rStatusDesc = 'Created'
        req.data.to_requestStatus_rStatus = 'MRCRTD'
        req.data.to_requestPhase_rPhase = 'MRINIT'
        req.data.to_requestPhase_rPhaseDesc = 'Initiation'
        //Change Status button will be enable after creating a record
        req.data.changeStatusFlag = true

        //Insert and update restrictions using hidden criteria
        //To set the request type disable after create
        //And request status to enable after create
        req.data.uiHidden = true
        req.data.uiHidden1 = false
        //To assign the Request type ID in requestTypeDisp -> It will enable at the time of edit with readonly field
        req.data.requestTypeDisp = req.data.to_requestType_ID
    });

    //This handler is used for creating and updating the request(Create and Update Handler)
    this.before(['CREATE', 'UPDATE'], 'MaintenanceRequests', async (req) => {

        //To store the value of BusinessPartnerName in database
        let query1 = await service2.read(BusinessPartnerVH).where({ BusinessPartner: req.data.businessPartner })
        if (req.data.businessPartner != null)
            req.data.businessPartnerName = query1[0].BusinessPartnerName

        //bpConcatenation is used for Overview page(bp + bp name)
        req.data.bpConcatenation = req.data.businessPartner + '(' + req.data.businessPartnerName + ')'
        console.log('bpConcatenation', req.data.bpConcatenation)

        //To store the value of WorkCenterText in database
        let query2 = await service2.read(WorkCenterVH).where({ WorkCenter: req.data.locationWC })
        if (req.data.locationWC != null) {
            req.data.locationWCDetail = query2[0].WorkCenterText
            // req.data.MaintenancePlanningPlant = query2[0].Plant
        }

        //To store the value of FunctionalLocationName in database
        let q1 = await service2.read(FunctionLocationVH).where({ functionalLocation: req.data.functionalLocation })
        if (req.data.functionalLocation != null)
            req.data.functionalLocationName = q1[0].FunctionalLocationName

        //To store the value of EquipmentName in database
        let q2 = await service2.read(EquipmentVH).where({ Equipment: req.data.equipment })
        if (req.data.equipment != null)
            req.data.equipmentName = q2[0].EquipmentName

        //To store the value of RevisionType &  RevisionText in database
        let q3 = await service2.read(RevisionVH).where({ RevisionNo: req.data.ManageRevision })
        if (req.data.ManageRevision != null)
        {
            req.data.MaintenanceRevision = req.data.ManageRevision
            req.data.revisionType = q3[0].RevisionType
            req.data.revisionText = q3[0].RevisionText
        }

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
        if (req.data.contract != null) {
            req.data.contractName = query3[0].SalesContractName
            tat = query3[0].TurnAroundTime
        }
        else
            req.data.contractName = ''

        //  if selected contract has tat value then tat + arrival date = delivery date
        //  date.addDays() method of adding days
        if (tat != null) {
            var result = new Date(req.data.expectedArrivalDate);
            const value = date.addDays(result, parseInt(tat));
            newFormatedDate = returnDate(value)
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

        //Assigning BP and BP Name to the fields of BP i.e. present on list page, so that it can filter accordingly
        req.data.businessPartnerDisp = req.data.businessPartner
        req.data.businessPartnerNameDisp = req.data.businessPartnerName

        //Assign values in start and end date which is store in database(Not in UI)
        req.data.startDate = req.data.expectedArrivalDate
        req.data.endDate = req.data.expectedDeliveryDate

        //Request Number field on list report page
        req.data.requestNoConcat = req.data.requestNo

        //Status and Phase value for list report page 
        req.data.to_requestStatusDisp_rStatus = req.data.to_requestStatus_rStatus
        req.data.to_requestStatusDisp_rStatusDesc = req.data.to_requestStatus_rStatusDesc

    });

    //This handler will handle all the values when you perform any opertaion on UI(Patch Handler)
    this.after('PATCH', 'MaintenanceRequests', async (req) => {
        //Fetch delivery date whenever user select the field at UI
        reqDeliveryDate = req.expectedDeliveryDate
    });

    //On click of Change Status(Second change status button)
    this.on('changeStatus', async (req) => {
        id1 = req.params[0].ID
        console.log('id1', id1)
        const tx1 = cds.transaction(req)
        query = await tx1.read(MaintenanceRequests).where({ ID: id1 })
        console.log('query................', query[0])
        queryStatus = await tx1.read(RequestStatuses).where({ rStatusDesc: req.data.status })
        console.log('query Status...............', queryStatus)
        queryPhase = await tx1.read(RequestPhases).where({ rPhase: queryStatus[0].to_rPhase_rPhase })
        console.log('query phase.............', queryPhase)

        //MR Status = Created & Selected Status = Request for New Worklist
        if (query[0].to_requestStatus_rStatus == 'MRCRTD' && queryStatus[0].rStatus == 'NWLREQ')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'MRCRTD' && queryStatus[0].rStatus != 'NWLREQ')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only move to next status Request for New Worklist')

        //MR Status = Request for New Worklist & Selected Status = New Worklist Requested
        else if (query[0].to_requestStatus_rStatus == 'NWLREQ' && queryStatus[0].rStatus == 'WLRQTD')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'NWLREQ' && queryStatus[0].rStatus != 'WLRQTD' && queryStatus[0].rStatus != 'NWLREQ')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only move to next status New Worklist Requested')
        else if (query[0].to_requestStatus_rStatus == 'NWLREQ' && queryStatus[0].rStatus == 'NWLREQ')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = New Worklist Requested  & Selected Status = New Worklist Received   
        else if (query[0].to_requestStatus_rStatus == 'WLRQTD' && queryStatus[0].rStatus == 'NWLREC')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'WLRQTD' && queryStatus[0].rStatus != 'NWLREC' && queryStatus[0].rStatus != 'WLRQTD')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only move to next status New Worklist Received')
        else if (query[0].to_requestStatus_rStatus == 'WLRQTD' && queryStatus[0].rStatus == 'WLRQTD')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = New Worklist Received  & Selected Status = New Worklist Screening
        else if (query[0].to_requestStatus_rStatus == 'NWLREC' && queryStatus[0].rStatus == 'NWLSCR')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'NWLREC' && queryStatus[0].rStatus != 'NWLSCR' && queryStatus[0].rStatus != 'NWLREC')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only move to next status New Worklist Screening')
        else if (query[0].to_requestStatus_rStatus == 'NWLREC' && queryStatus[0].rStatus == 'NWLREC')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = New Worklist Screening  & Selected Status = New Worklist Validated or New Worklist Requested
        else if (query[0].to_requestStatus_rStatus == 'NWLSCR' && (queryStatus[0].rStatus == 'NWLVAL' || queryStatus[0].rStatus == 'WLRQTD'))
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'NWLSCR' && (queryStatus[0].rStatus != 'NWLVAL' || queryStatus[0].rStatus != 'WLRQTD') && queryStatus[0].rStatus != 'NWLSCR')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only move to next status New Worklist Validated or New Worklist Requested')
        else if (query[0].to_requestStatus_rStatus == 'NWLSCR' && queryStatus[0].rStatus == 'NWLSCR')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = New Worklist Validated  & Selected Status = New Worklist Created
        else if (query[0].to_requestStatus_rStatus == 'NWLVAL' && queryStatus[0].rStatus == 'WLCRTD') {
            var queryWorkItem = await service4.read('MaintenanceRequestHeader').where({ requestNo: query[0].requestNo })
            console.log('queryWorkItem ', queryWorkItem)
            //check one condition (If atleast one workitem is created for particular MR the it allo to change the status to New Worklist Created)
            //(.length doesnot work in HANA)
            if (queryWorkItem[0] != null) {
                updateStatus()
            }
            else {
                req.error(406, 'For Request ' + query[0].requestNoConcat + ' WorkItem is not created.')
            }
        }
        else if (query[0].to_requestStatus_rStatus == 'NWLVAL' && queryStatus[0].rStatus != 'WLCRTD' && queryStatus[0].rStatus != 'NWLVAL')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only move to next status New Worklist Created')
        else if (query[0].to_requestStatus_rStatus == 'NWLVAL' && queryStatus[0].rStatus == 'NWLVAL')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = New Worklist Created & Selected Status = All Worklists Received
        else if (query[0].to_requestStatus_rStatus == 'WLCRTD' && queryStatus[0].rStatus == 'AWLREC')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'WLCRTD' && queryStatus[0].rStatus != 'AWLREC' && queryStatus[0].rStatus != 'WLCRTD')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only move to next status All Worklists Received')
        else if (query[0].to_requestStatus_rStatus == 'WLCRTD' && queryStatus[0].rStatus == 'WLCRTD')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = All Worklists Received & Selected Status = Ready for Approval state or New Worklist Received
        else if (query[0].to_requestStatus_rStatus == 'AWLREC' && (queryStatus[0].rStatus == 'APRRDY' || queryStatus[0].rStatus == 'NWLREC'))
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'AWLREC' && (queryStatus[0].rStatus != 'APRRDY' || queryStatus[0].rStatus != 'NWLREC') && queryStatus[0].rStatus != 'AWLREC')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only move to next status Ready for Approval state or New Worklist Received')
        else if (query[0].to_requestStatus_rStatus == 'AWLREC' && queryStatus[0].rStatus == 'AWLREC')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = Ready for Approval & Selected Status = Approved
        else if (query[0].to_requestStatus_rStatus == 'APRRDY' && queryStatus[0].rStatus == 'MRAPRD')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'APRRDY' && queryStatus[0].rStatus != 'MRAPRD' && queryStatus[0].rStatus != 'APRRDY')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only move to next status Approved')
        else if (query[0].to_requestStatus_rStatus == 'APRRDY' && queryStatus[0].rStatus == 'APRRDY')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = Approved & Selected Status = Task List Identified
        else if (query[0].to_requestStatus_rStatus == 'MRAPRD' && queryStatus[0].rStatus == 'TLIDNT') {
            updateStatus()
            //update the status to task list identified and enable the Revision Create button
            await UPDATE(MaintenanceRequests).set({
                updateRevisionFlag: true
            }).where({ ID: id1 })
        }
        else if (query[0].to_requestStatus_rStatus == 'MRAPRD' && queryStatus[0].rStatus != 'TLIDNT' && queryStatus[0].rStatus != 'MRAPRD')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only move to next status Task List Identified')
        else if (query[0].to_requestStatus_rStatus == 'MRAPRD' && queryStatus[0].rStatus == 'MRAPRD')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = Task List Identified & Selected Status is not equal to task list identified -> then it will give error msg that Revision is required
        else if (query[0].to_requestStatus_rStatus == 'TLIDNT' && queryStatus[0].rStatus != 'TLIDNT')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and Revision is required to move in further state')
        else if (query[0].to_requestStatus_rStatus == 'TLIDNT' && queryStatus[0].rStatus == 'TLIDNT')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = Revision Created & selected status = Notifications Created
        else if (query[0].to_requestStatus_rStatus == 'RVCRTD' && queryStatus[0].rStatus == 'NTCRTD')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'RVCRTD' && queryStatus[0].rStatus != 'NTCRTD' && queryStatus[0].rStatus != 'RVCRTD')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only move to next status Notifications Created')
        else if (query[0].to_requestStatus_rStatus == 'RVCRTD' && queryStatus[0].rStatus == 'RVCRTD')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = Notifications Created & selected status = Document Completed
        else if (query[0].to_requestStatus_rStatus == 'NTCRTD' && queryStatus[0].rStatus == 'MRCMPL') {
            updateStatus()
            //Disable the change status action button
            await UPDATE(MaintenanceRequests).set({
                changeStatusFlag: false
            }).where({ ID: id1 })
        }
        else if (query[0].to_requestStatus_rStatus == 'NTCRTD' && queryStatus[0].rStatus != 'MRCMPL' && queryStatus[0].rStatus != 'NTCRTD')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only move to next status Document Completed')
        else if (query[0].to_requestStatus_rStatus == 'NTCRTD' && queryStatus[0].rStatus == 'NTCRTD')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        else if (query[0].to_requestStatus_rStatus == 'NTCRTD' && queryStatus[0].rStatus == 'MRCMPL')
            req.error(406, 'MR ' + query[0].requestNoConcat + ' is Completed')
        else if (query[0].to_requestStatus_rStatus == 'MRCMPL' && queryStatus[0].rStatus != 'MRCMPL')
            req.error(406, 'MR ' + query[0].requestNoConcat + ' is already Completed')
        else if (query[0].to_requestStatus_rStatus == 'MRCMPL' && queryStatus[0].rStatus == 'MRCMPL')
            req.error(406, 'MR ' + query[0].requestNoConcat + ' is already Completed')
    });

    //Handler for Create Revision Action button
    this.on('revisionCreated', async (req) => {
        // for (let i = 0; i < req.params.length; i++) {
        const id1 = req.params[0].ID
        const tx1 = cds.transaction(req)
        var queryStatus = await tx1.read(RequestStatuses).where({ rStatusDesc: 'Revision Created' })
        console.log('query', queryStatus)
        var queryPhase = await tx1.read(RequestPhases).where({ rPhaseDesc: 'Preparation' })
        console.log('query', queryPhase)
        var query = await tx1.read(MaintenanceRequests).where({ ID: id1 })
        console.log('query...........', query)
        if (query[0].ManageRevision != null) {
            await UPDATE(MaintenanceRequests).set({
                to_requestStatus_rStatus: 'RVCRTD',
                to_requestStatusDisp_rStatus: 'RVCRTD',
                to_requestStatus_rStatusDesc: 'Revision Created',
                to_requestStatusDisp_rStatusDesc: 'Revision Created',
                to_requestPhase_rPhase: 'MRPREP',
                to_requestPhase_rPhaseDesc: 'Preparation',
                updateRevisionFlag: false
            }).where({ ID: id1 })
        }
        else {
            if (query[0].to_requestStatus_rStatus == 'TLIDNT') {

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
                            await UPDATE(MaintenanceRequests).set({
                                ManageRevision: result.RevisionNo,
                                MaintenanceRevision: result.RevisionNo,
                                revisionType: result.RevisionType,
                                revisionText: result.RevisionText,
                                to_requestStatus_rStatus: 'RVCRTD',
                                to_requestStatusDisp_rStatus: 'RVCRTD',
                                to_requestStatus_rStatusDesc: 'Revision Created',
                                to_requestStatusDisp_rStatusDesc: 'Revision Created',
                                to_requestPhase_rPhase: 'MRPREP',
                                to_requestPhase_rPhaseDesc: 'Preparation',
                                updateRevisionFlag: false
                            }).where({ ID: id1 })
                            req.info(101, 'Revision ' + result.RevisionNo + ' created for Maintenance Request ' + query[0].requestNoConcat)
                            return result
                        }
                    }
                    catch (error) {
                        var vstatusCode = error.statusCode
                        var verrorMessage = error.innererror.response.body.error.message.value
                        req.error(406, 'Error Code : ' + vstatusCode + ' Error Message : ' + verrorMessage)
                    }
                }

            }
            /* else if (query[0].to_requestStatus_rStatus == 'NTCRTD' || query[0].to_requestStatus_rStatus == 'RVCRTD') {
                 req.data.to_requestStatus_rStatus = 'RVCRTD'
                 req.info(101, 'For Request ' + query[0].requestNoConcat + ' Revision is already been created')
             }
             else if (query[0].to_requestStatus_rStatus == 'MRCMPL') {
                 req.info(101, 'MR ' + query[0].requestNoConcat + ' is already Completed')
             }
             else if (query[0].to_requestStatus_rStatus != 'NTCRTD' || query[0].to_requestStatus_rStatus != 'MRCMPL' || query[0].to_requestStatus_rStatus != 'TLIDNT')
                 req.info(101, 'For Request ' + query[0].requestNoConcat + ' Task List should be identified')*/
            //}
        }


    });

    //Handler for Calculate Ageing
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
    });

    //Handler for change documnet status and handling it in bot
    this.on('changeDocumentStatus', async (req) => {
        var ID = req.data.ID;
        var status = req.data.status;
        console.log('ID', ID);
        console.log('Status', status);

        var query1 = await SELECT.from(Documents).columns('*').where({ UUID: ID });
        console.log('query', query1);

        var query2 = await SELECT.from(DocumentStatuses).columns('*').where({ docStatus: status });
        console.log('query2', query2);

        console.log('query2.statusDesc', query2[0].statusDesc);
        var result = await UPDATE(Documents).set({
            to_documentStatus_ID: query2[0].ID,
            to_documentStatus_docStatus: query2[0].docStatus,
            to_documentStatus_docStatusDesc: query2[0].docStatusDesc
        }).where({ UUID: ID });

        return result;

    });

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
    };

    //Function for Update Status in validation of statuses on (changeStatus handler)
    async function updateStatus() {
        await UPDATE(MaintenanceRequests).set({
            to_requestStatus_rStatus: queryStatus[0].rStatus,
            to_requestStatus_rStatusDesc: queryStatus[0].rStatusDesc,
            to_requestStatusDisp_rStatus: queryStatus[0].rStatus,
            to_requestStatusDisp_rStatusDesc: queryStatus[0].rStatusDesc,
            to_requestPhase_rPhase: queryPhase[0].rPhase,
            to_requestPhase_rPhaseDesc: queryPhase[0].rPhaseDesc
        }).where({ ID: id1 })
    };
})

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
