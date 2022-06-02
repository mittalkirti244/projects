const cds = require('@sap/cds')
const date = require('date-and-time')
cds.env.features.fetch_csrf = true
const validatePhoneNumber = require('validate-phone-number-node-js');
var validator = require("email-validator");

module.exports = cds.service.impl(async function () {
    const {
        MaintenanceRequests,
        RequestTypes,
        BusinessPartnerVH,
        WorkCenterVH,
        FunctionLocationVH,
        NumberRanges,
        SalesContractVH,
        EquipmentVH,
        Revisions,
        SalesContractItemVH,
        UnitOfMeasureVH,
        Documents
    } = this.entities
    const service1 = await cds.connect.to('NumberRangeService');
    const service2 = await cds.connect.to('alphamasterService');
    const service3 = await cds.connect.to('MAINTREQ_SB');

    var newFormatedDate, tat, reqDeliveryDate, assignedDeliveryDate, vnumberRangeID;

    var vplanningPlant, vrevisionText, vworkCenter, vworkCenterPlant, vrevisionStartDate, vrevisionEndDate, vfunctionalLocation, vequipment, reqwcPlant, reqwcDetail
    let cvalue = 1;
    var vforeCastDays, vforeCastDate, vdiffInCurrentAndArrivalDate, vdiffInArrivalAndDeliveryDate

    this.on('READ', NumberRanges, req => {
        return service1.tx(req).run(req.query);
    });

    this.on('READ', [BusinessPartnerVH, WorkCenterVH, FunctionLocationVH, SalesContractVH, EquipmentVH, Revisions, SalesContractItemVH,
        UnitOfMeasureVH], req => {
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
        if (req.data.to_requestStatus_rStatus == 'Confirmed' || req.data.to_requestStatus_rStatus == '') {
            req.data.to_requestStatus_rStatus = 'Draft'
            req.data.to_requestPhase_rPhase = 'Initial'
            req.info(101, 'Request Status should always be Draft when you create a new Maintenance Request')
        }

        //Insert and update restrictions using hidden criteria
        //To set the request type disable after create
        //And request status to enable after create
        req.data.uiHidden = true
        req.data.uiHidden1 = false
        req.data.requestType1 = req.data.to_requestType_ID
    });

    this.before(['CREATE', 'UPDATE'], 'MaintenanceRequests', async (req) => {

        // To make business partner name as readonly field
        let query1 = await service2.read(BusinessPartnerVH)
        var bp = req.data.businessPartner
        for (let i = 0; i < query1.length; i++) {
            if (bp == query1[i].BusinessPartner) {
                req.data.businessPartnerName = query1[i].BusinessPartnerName
            }
        }

        req.data.bpConcatenation = req.data.businessPartner + '(' + req.data.businessPartnerName + ')'
        console.log('bpConcatenation', req.data.bpConcatenation)

        //To make location WC plant and location detail as readonly field
        let query2 = await service2.read(WorkCenterVH)
        var locWC = req.data.locationWC
        for (let i = 0; i < query2.length; i++) {
            if (locWC == query2[i].WorkCenter) {
                req.data.locationWCDetail = query2[i].WorkCenterText
                // req.data.MaintenancePlanningPlant = query2[i].Plant
            }
        }

        //To make functional location name as readonly field
        let q1 = await service2.read(FunctionLocationVH)
        var floc = req.data.functionalLocation
        for (let i = 0; i < q1.length; i++) {
            if (floc == q1[i].functionalLocation) {
                req.data.functionalLocationName = q1[i].FunctionalLocationName
            }
        }

        //To make equipment name as readonly field
        let q2 = await service2.read(EquipmentVH)
        var equip = req.data.equipment
        for (let i = 0; i < q2.length; i++) {
            if (equip == q2[i].Equipment) {
                req.data.equipmentName = q2[i].EquipmentName
            }
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
            req.error(406, 'Please enter a valid Email Address')

        //To fetch the tat and contract name from contract service
        let query3 = await service2.read(SalesContractVH)
        var contract = req.data.contract
        console.log('contract', contract)
        if (req.data.contract != null) {
            for (let i = 0; i < query3.length; i++) {
                if (contract == query3[i].SalesContract) {
                    req.data.contractName = query3[i].SalesContractName
                    tat = query3[i].TurnAroundTime
                    // console.log('tat value :', tat)
                }
            }
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

        // req.data.foreCastDays = calculateForeCastDays(req.data.expectedDeliveryDate)
        // req.data.foreCastDays = 11
        req.data.foreCastDate = calculateForeCastDate(req.data.expectedDeliveryDate)
        req.data.diffInCurrentAndArrivalDate = calculateDiffInCurrentAndArrivalDate(req.data.expectedArrivalDate)
        req.data.diffInDeliveryAndArrivalDate = calculateDiffInDeliveryAndArrivalDate(req.data.expectedDeliveryDate, req.data.expectedArrivalDate)

        console.log('req.data.foreCastDays', req.data.foreCastDays)
        console.log('req.data.foreCastDate', req.data.foreCastDate)
        console.log('req.data.diffInCurrentAndArrivalDate', req.data.diffInCurrentAndArrivalDate)
        console.log('req.data.diffInDeliveryAndArrivalDate', req.data.diffInDeliveryAndArrivalDate)

        req.data.startDate = req.data.expectedArrivalDate
        req.data.endDate = req.data.expectedDeliveryDate

    });

    this.before('UPDATE', 'MaintenanceRequests', async (req) => {

        // the request phase will change after selecting request status from edit screen
        if (req.data.to_requestStatus_rStatus == 'Confirmed') {
            req.data.to_requestPhase_rPhase = 'Planning'
        }

        //Fetching planning plant, request desc, work center and arrival and delivery date for performing POST request to MaintRevision S4 Service
        //Mandatory fields for creating a revision
        if (reqwcPlant == null) {
            vplanningPlant = req.data.MaintenancePlanningPlant
        }
        else {
            vplanningPlant = reqwcPlant
        }
        //Revision text will contain Request description + request Number
        vrevisionText = req.data.requestNo + ' ' + req.data.requestDesc
        vworkCenter = req.data.locationWC

        //After selecting thw workcenter that is coming from patch
        //supose user refresh the screen then plant will get removed -> if else condition is used to resolve this issue
        if (reqwcPlant == null) {
            vworkCenterPlant = req.data.MaintenancePlanningPlant
        }
        else {
            vworkCenterPlant = reqwcPlant
        }
        /* /Date(1224043200000)/ */
        var vexpectedArrivalDate = new Date(req.data.expectedArrivalDate)
        var vformatexpectedArrivalDate = '/Date(' + vexpectedArrivalDate.getTime() + ')/'
        //console.log('vformatexpectedArrivalDate', vformatexpectedArrivalDate)
        vrevisionStartDate = req.data.expectedArrivalDate
        var vexpectedDeliveryDate = new Date(req.data.expectedDeliveryDate)
        var vformatedexpectedDeliveryDate = '/Date(' + vexpectedDeliveryDate.getTime() + ')/'
        // console.log('vformatedexpectedDeliveryDate', vformatedexpectedDeliveryDate)
        vrevisionEndDate = req.data.expectedDeliveryDate
        vfunctionalLocation = req.data.functionalLocation
        vequipment = req.data.equipment

        //Revision will trigger when requestphase will change from intial to planning
        if (req.data.to_requestPhase_rPhase == 'Planning') {
            //One request should always have 1 MR
            if (req.data.MaintenanceRevision == null) {
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
                        // console.log('result', result)
                        req.data.MaintenanceRevision = result.RevisionNo
                        req.data.revisionType = result.RevisionType
                        req.data.revisionText = result.RevisionText
                        // console.log(' result.FunctionLocation value is ', result.FunctionLocation)
                        // console.log(' result.Equipment value is ', result.Equipment)
                        req.info(101, 'Revision ' + req.data.MaintenanceRevision + ' created')
                        req.data.to_requestStatus_rStatus = 'Revision Created'
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
            else if (req.data.MaintenanceRevision != null && req.data.to_requestStatus_rStatus == 'Confirmed') {
                req.data.to_requestStatus_rStatus = 'Revision Created'
                req.info(101, 'Revision is already been created for this Maintenance Request')
            }
        }

    });

    this.after('PATCH', 'MaintenanceRequests', async (req) => {
        //Fetch delivery date whenever user select the field at UI
        reqDeliveryDate = req.expectedDeliveryDate
        //console.log('Value of selectedDeliveryDate: ', reqDeliveryDate)
    });

    this.on('requestMail', async (req) => {
        for (let i = 0; i < req.params.length; i++) {
            const id1 = req.params[i].ID
            //console.log('id1', id1)
            const tx1 = cds.transaction(req)

            var query = await tx1.read(MaintenanceRequests).where({ ID: id1 })
            //console.log('query.........', query[i].to_botStatus_ID)

            if (query[i].MaintenanceRevision != null && query[i].to_botStatus_ID != 1) {
                req.info(101, 'Request for Mail sent.')

                const affectedRows = await UPDATE(MaintenanceRequests).set({
                    to_botStatus_ID: 1,
                    to_botStatus_bStatus: 'Mail Requested'
                }).where({ ID: query[i].ID })
            }
            else {
                if (query[i].revisMaintenanceRevisionionNo == null && query[i].to_botStatus_ID == 1) {
                    req.error(406, 'Email cannot be sent, as Revision is not created for Maintenance Request ' + query[i].requestNo)
                } else if (query[i].MaintenanceRevision == null) {
                    req.error(406, 'Email cannot be sent, as Revision is not created for Maintenance Request ' + query[i].requestNo)
                } else if (query[i].to_botStatus_ID == 1) {
                    req.error(406, 'Email already sent for Maintenance Request ' + query[i].requestNo)
                }
            }
        }
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
    }

    /*function calculateForeCastDays(deliveryDate) {
        //Total ForeCast days -> 11
        vforeCastDays = new Date(deliveryDate).getDate() + 10
        console.log('Forecast Days', vforeCastDays)
        return vforeCastDays;
    }*/

    function calculateForeCastDate(deliveryDate) {
        //Date after adding buffer days
        var newDate = new Date(deliveryDate);
        vforeCastDate = returnDate(newDate.setDate(newDate.getDate() + 10))
        console.log('date After adding Forecast date', vforeCastDate)

        return vforeCastDate
    }

    function calculateDiffInCurrentAndArrivalDate(arrivalDate) {
        var vdifferenceInTime = new Date().getTime() - new Date(arrivalDate).getTime();

        // To calculate the no. of days between two dates
        var vdifferenceInDays = vdifferenceInTime / (1000 * 3600 * 24);

        //To display the final no. of days
        vdiffInCurrentAndArrivalDate = Math.trunc(vdifferenceInDays)
        console.log('Difference in Current and Arrival Date ', vdiffInCurrentAndArrivalDate)

        return vdiffInCurrentAndArrivalDate
    }

    function calculateDiffInDeliveryAndArrivalDate(deliveryDate, arrivalDate) {
        var vdifferenceInTime = new Date(deliveryDate).getTime() - new Date(arrivalDate).getTime();

        // To calculate the no. of days between two dates
        var vdifferenceInDays = vdifferenceInTime / (1000 * 3600 * 24);

        //To display the final no. of days
        vdiffInArrivalAndDeliveryDate = Math.trunc(vdifferenceInDays)
        console.log('Difference in Delivery and Arrival Date', vdiffInArrivalAndDeliveryDate)

        return vdiffInArrivalAndDeliveryDate

    }
})