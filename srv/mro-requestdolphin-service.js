const cds = require('@sap/cds')
const date = require('date-and-time')
cds.env.features.fetch_csrf = true
const validatePhoneNumber = require('validate-phone-number-node-js');
var validator = require("email-validator");
var express = require("express");
var app = express();
var request = require("request");

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
        WorkItems,
        RequestStatusesDisp,
        MaintNotifications,
        ReferenceTaskListVH,
        WorkItemTypes,
        RequestTypeConfig,
        NotificationTypes,
        SalesOrgVH,
        xHCLPRODSxC_Bow,
        ServiceProducts,
        Currencies } = this.entities
    const service1 = await cds.connect.to('NumberRangeService');
    const service2 = await cds.connect.to('MAINTREQ_SB');
    const service3 = await cds.connect.to('REUSABLE_SB');
    const service4 = await cds.connect.to('BOW');
    const service5 = await cds.connect.to('BOW_CREATE_SRV');

    var newFormatedDate, tat, assignedDeliveryDate;
    var queryStatus, queryPhase, query;
    var id1;
    var vplanningPlant, vrevisionText, vworkCenter, vworkCenterPlant, vrevisionStartDate, vrevisionEndDate, vfunctionalLocation, vequipment, reqwcPlant
    let cvalue = 1;

    //Read the NumberRanges entity from Number Range Service
    this.on('READ', NumberRanges, req => {
        return service1.tx(req).run(req.query);
    });

    //Read the BusinessPartnerVH, WorkCenterVH, FunctionLocationVH, SalesContractVH, EquipmentVH, Revisions entity from S4(MaintReq).
    this.on('READ', [BusinessPartnerVH, WorkCenterVH, FunctionLocationVH, SalesContractVH, EquipmentVH, RevisionVH, MaintNotifications, ReferenceTaskListVH], req => {
        return service2.tx(req).run(req.query);
    });

    //Read Sales Organization
    this.on('READ', SalesOrgVH, req => {
        return service3.tx(req).run(req.query);
    });

    this.on('READ', xHCLPRODSxC_Bow, req => {
        return service4.tx(req).run(req.query);
    });

    this.on('READ', [ServiceProducts, Currencies], req => {
        return service5.tx(req).run(req.query);
    });

    //Custom handler for new create(To load details at the time of first CREATE Button i.e., present on list page)
    this.before('NEW', 'MaintenanceRequests', async (req) => {

        //Assigning the current date into all date fields at the time of new create
        req.data.expectedArrivalDate = returnDate(new Date())
        req.data.expectedDeliveryDate = returnDate(new Date())
        req.data.startDate = returnDate(new Date())
        req.data.endDate = returnDate(new Date())
        req.data.createdAtDate = returnDate(new Date())

        //Used in Overview Page
        req.data.mrCount = cvalue
        console.log('req.data.mrCount', req.data.mrCount + 1)
    });

    //This handler is used while creating a record(Create Handler)
    this.before('CREATE', 'MaintenanceRequests', async (req) => {

        //Fetching the concatenated number from Number range and storing it to request Number of MR
        var query = await SELECT.from(RequestTypes).columns('*').where({ rType: req.data.to_requestType_rType })
        console.log('query', query)
        var query1 = await service1.read(NumberRanges).columns('*').where({ numberRangeID: query[0].rType })
        console.log('query1', query1)
        if (query1[0] != null) {
            if (req.data.to_requestType_rType == query1[0].numberRangeID) {
                try {
                    const nrID = await service1.getLastRunningNumber(query1[0].numberRangeID)
                    req.data.requestNo = nrID
                    vnumberRangeID = query1[0].numberRangeID
                } catch (error) {
                    var verrorMessage = error.innererror.response.body.error.message
                    req.error(406, verrorMessage)
                }
            }
        }
        else {
            //If Request Type is not present in Number Range, it will give Info msg
            //(If selected request type is not there in Number Range)
            req.error(406, req.data.to_requestType_rType + ' Type is not maintained in NumberRange.')
        }

        //Data to be filled at the time of creating a new record
        req.data.to_requestStatus_rStatus = 'MRCRTD'
        req.data.to_requestStatus_rStatusDesc = 'Created'
        req.data.to_requestPhase_rPhase = 'MRINIT'
        req.data.to_requestPhase_rPhaseDesc = 'Initiation'
        //Change Status button will be enabled after creating a record
        req.data.changeStatusFlag = true

        //Insert and update restrictions using hidden criteria
        //To set the request type disable after create
        //And request status to enable after create
        req.data.uiHidden = true
        req.data.uiHidden1 = false
        //To assign the Request type ID in requestTypeDisp -> It will enable at the time of edit with readonly field
        req.data.requestTypeDisp = req.data.to_requestType_rType
    });

    //This handler is used for creating and updating the request(Create and Update Handler)
    this.before(['CREATE', 'UPDATE'], 'MaintenanceRequests', async (req) => {

        //bpConcatenation is used for Overview page(bp + bp name)
        req.data.bpConcatenation = req.data.businessPartner + '(' + req.data.businessPartnerName + ')'
        console.log('bpConcatenation', req.data.bpConcatenation)

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
        if (emailCheck == false && req.data.ccemail != '') {
            req.error(406, 'Please enter a valid E-Mail Address')
        }

        //To fill the Floc Name for text arrangement When Equipment is selecting before the Floc.
        if (req.data.functionalLocation != null && req.data.functionalLocation != '') {
            let queryFloc = await service2.read(FunctionLocationVH).where({ functionalLocation: req.data.functionalLocation })
            req.data.functionalLocationName = queryFloc[0].FunctionalLocationName
        }

        //To fetch the tat and contract name from contract service
        if (req.data.SalesContract != '') {
            let query3 = await service2.read(SalesContractVH).where({ SalesContract: req.data.SalesContract })
            req.data.contractName = query3[0].SalesContractName
            tat = query3[0].TurnAroundTime
            console.log('tat', tat)
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

        var queryDate = await SELECT.from(MaintenanceRequests).columns('*').where({ ID: req.data.ID });
        if (queryDate[0] != null) {
            reqDeliveryDate = queryDate[0].expectedDeliveryDate
        }

        var newCurrentDate = returnDate(new Date())
        var reqDeliveryDate = returnDate(reqDeliveryDate)

        if (req.data.SalesContract == null) {
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
        console.log('req.data.requestNoConcat', req.data.requestNoConcat)

        //Status and Phase value for list report page 
        req.data.to_requestStatusDisp_rStatus = req.data.to_requestStatus_rStatus
        req.data.to_requestStatusDisp_rStatusDesc = req.data.to_requestStatus_rStatusDesc

        //If user manually removes the text arrangement fields, then it become null
        //If User removes the Plant field
        if (req.data.MaintenancePlanningPlant == '') {
            req.data.plantName = null
            req.data.MaintenancePlanningPlant = null
        }

        //If user manually removes equipment
        if (req.data.equipment == '') {
            req.data.equipment = null
            req.data.equipmentName = null
        }

        //If user manually removes the floc
        if (req.data.functionalLocation == '') {
            req.data.functionalLocation = null
            req.data.functionalLocationName = null
        }

        // If user manully remove Revision 
        if (req.data.MaintenanceRevision == '') {
            req.data.MaintenanceRevision = null
            req.data.revisionText = null
        }

    });

    //This handler is used while creating a Document record(Create Handler)
    this.before('NEW', 'MaintenanceRequests/to_document', async (req) => {

        //To Generate the Number for Document from Number Range Service
        //Document is a number Range ID in Number Range Service
        var query1 = await service1.read(NumberRanges).columns('*').where({ numberRangeID: 'Document' })
        console.log('query1', query1)
        if (query1[0] != null) {
            const nrID = await service1.getLastRunningNumber(query1[0].numberRangeID)
            req.data.ID = nrID
            console.log('req.data.ID', req.data.ID)
        } else {
            req.error(406, 'Document ID is not maintained in NumberRange.')
        }

        //fetching all the records in the RequestStatusesDisp - used to fetch status detail
        var query = await SELECT.from(RequestStatusesDisp).columns('*');
        //fetch the all MR Details using the ID
        var query1 = await SELECT.from(MaintenanceRequests).columns('*').where({ ID: req.data.to_maintenanceRequest_ID });
        if (query1[0] != null) {
            if (query1[0].to_requestStatusDisp_rStatus == query[7].rStatus || query1[0].to_requestStatusDisp_rStatus == query[8].rStatus || query1[0].to_requestStatusDisp_rStatus == query[9].rStatus || query1[0].to_requestStatusDisp_rStatus == query[10].rStatus || query1[0].to_requestStatusDisp_rStatus == query[11].rStatus || query1[0].to_requestStatusDisp_rStatus == query[12].rStatus || query1[0].to_requestStatusDisp_rStatus == query[13].rStatus) {
                req.error(406, 'For Request ' + query1[0].requestNo + ' current status is ' + query1[0].to_requestStatus_rStatusDesc + '. New documents cannot be created.');
            }
        }
    });

    //On click of Change Status(Second change status button)
    this.on('changeStatus', async (req) => {
        id1 = req.params[0].ID
        const tx1 = cds.transaction(req)
        query = await tx1.read(MaintenanceRequests).where({ ID: id1 })
        queryStatus = await tx1.read(RequestStatuses).where({ rStatusDesc: req.data.status })
        queryPhase = await tx1.read(RequestPhases).where({ rPhase: queryStatus[0].to_rPhase_rPhase })
        queryStatusDisp = await tx1.read('RequestStatusesDisp')

        //MR Status = Created & Selected Status = Request for New Worklist
        if (query[0].to_requestStatus_rStatus == 'MRCRTD' && queryStatus[0].rStatus == 'NWLREQ')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'MRCRTD' && queryStatus[0].rStatus != 'NWLREQ')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only proceed to next status ' + queryStatusDisp[1].rStatusDesc)

        //MR Status = Request for New Worklist & Selected Status = New Worklist Requested
        else if (query[0].to_requestStatus_rStatus == 'NWLREQ' && queryStatus[0].rStatus == 'WLRQTD')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'NWLREQ' && queryStatus[0].rStatus != 'WLRQTD' && queryStatus[0].rStatus != 'NWLREQ')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only proceed to next status ' + queryStatusDisp[2].rStatusDesc)
        else if (query[0].to_requestStatus_rStatus == 'NWLREQ' && queryStatus[0].rStatus == 'NWLREQ')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = New Worklist Requested  & Selected Status = New Worklist Received   
        else if (query[0].to_requestStatus_rStatus == 'WLRQTD' && queryStatus[0].rStatus == 'NWLREC')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'WLRQTD' && queryStatus[0].rStatus != 'NWLREC' && queryStatus[0].rStatus != 'WLRQTD')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only proceed to next status ' + queryStatusDisp[3].rStatusDesc)
        else if (query[0].to_requestStatus_rStatus == 'WLRQTD' && queryStatus[0].rStatus == 'WLRQTD')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = New Worklist Received  & Selected Status = New Worklist Screening
        else if (query[0].to_requestStatus_rStatus == 'NWLREC' && queryStatus[0].rStatus == 'NWLSCR')
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'NWLREC' && queryStatus[0].rStatus != 'NWLSCR' && queryStatus[0].rStatus != 'NWLREC')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only proceed to next status ' + queryStatusDisp[4].rStatusDesc)
        else if (query[0].to_requestStatus_rStatus == 'NWLREC' && queryStatus[0].rStatus == 'NWLREC')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = New Worklist Screening  & Selected Status = New Worklist Validated or New Worklist Requested
        else if (query[0].to_requestStatus_rStatus == 'NWLSCR' && (queryStatus[0].rStatus == 'NWLVAL' || queryStatus[0].rStatus == 'WLRQTD'))
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'NWLSCR' && (queryStatus[0].rStatus != 'NWLVAL' || queryStatus[0].rStatus != 'WLRQTD') && queryStatus[0].rStatus != 'NWLSCR')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only proceed to next status ' + queryStatusDisp[5].rStatusDesc + ' or ' + queryStatusDisp[2].rStatusDesc)
        else if (query[0].to_requestStatus_rStatus == 'NWLSCR' && queryStatus[0].rStatus == 'NWLSCR')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = New Worklist Validated  & Selected Status = New Worklist Created
        else if (query[0].to_requestStatus_rStatus == 'NWLVAL' && queryStatus[0].rStatus == 'WLCRTD') {

            var queryWorkItem = await tx1.read('WorkItems').where({ requestNo: query[0].requestNo })

            //check one condition (If atleast one workitem is created for particular MR the it allo to change the status to New Worklist Created)
            //(.length doesnot work in HANA)
            if (queryWorkItem[0] != null) {
                updateStatus()
            }
            else {
                req.error(406, 'For Request ' + query[0].requestNoConcat + ' WorkItem is not created.')
            }
        }
        //MR Status = New Worklist Validated  & Selected Status = New Worklist Requested and New Worklist Received
        else if (query[0].to_requestStatus_rStatus == 'NWLVAL' && (queryStatus[0].rStatus == 'WLRQTD' || queryStatus[0].rStatus == 'NWLREC')) {
            updateStatus()
        }
        else if (query[0].to_requestStatus_rStatus == 'NWLVAL' && queryStatus[0].rStatus != 'WLCRTD' && queryStatus[0].rStatus != 'NWLVAL' && queryStatus[0].rStatus != 'WLRQTD' && queryStatus[0].rStatus != 'NWLREC')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only proceed to next status ' + queryStatusDisp[6].rStatusDesc + ', ' + queryStatusDisp[2].rStatusDesc + ' or ' + queryStatusDisp[3].rStatusDesc)
        else if (query[0].to_requestStatus_rStatus == 'NWLVAL' && queryStatus[0].rStatus == 'NWLVAL')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = New Worklist Created & Selected Status = New Worklist Requested , New Worklists Received, All Worklists Received
        else if (query[0].to_requestStatus_rStatus == 'WLCRTD' && (queryStatus[0].rStatus == 'WLRQTD' || queryStatus[0].rStatus == 'NWLREC' || queryStatus[0].rStatus == 'AWLREC'))
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'WLCRTD' && queryStatus[0].rStatus != 'WLCRTD' && queryStatus[0].rStatus != 'WLRQTD' && queryStatus[0].rStatus != 'NWLREC' && queryStatus[0].rStatus != 'AWLREC')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only proceed to next status ' + queryStatusDisp[2].rStatusDesc + ', ' + queryStatusDisp[3].rStatusDesc + ' or ' + queryStatusDisp[7].rStatusDesc)
        else if (query[0].to_requestStatus_rStatus == 'WLCRTD' && queryStatus[0].rStatus == 'WLCRTD')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = All Worklists Received & Selected Status = Ready for Approval and previous all statuses
        else if (query[0].to_requestStatus_rStatus == 'AWLREC' && (queryStatus[0].rStatus == 'APRRDY' || queryStatus[0].rStatus == 'NWLREQ' || queryStatus[0].rStatus == 'WLRQTD' || queryStatus[0].rStatus == 'NWLREC' || queryStatus[0].rStatus == 'NWLSCR' || queryStatus[0].rStatus == 'NWLVAL' || queryStatus[0].rStatus == 'WLCRTD'))
            updateStatus()
        else if (query[0].to_requestStatus_rStatus == 'AWLREC' && queryStatus[0].rStatus != 'APRRDY' && queryStatus[0].rStatus != 'AWLREC' && queryStatus[0].rStatus != 'NWLREQ' && queryStatus[0].rStatus != 'WLRQTD' && queryStatus[0].rStatus != 'NWLREC' && queryStatus[0].rStatus != 'NWLSCR' && queryStatus[0].rStatus != 'NWLVAL' && queryStatus[0].rStatus != 'WLCRTD')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only proceed to next status ' + queryStatusDisp[8].rStatusDesc + ' and to previous statuses.')
        else if (query[0].to_requestStatus_rStatus == 'AWLREC' && queryStatus[0].rStatus == 'AWLREC')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = Ready for Approval & Selected Status = Approved and Previous all statuses
        else if (query[0].to_requestStatus_rStatus == 'APRRDY') {
            if (queryStatus[0].rStatus == 'MRAPRD') {
                console.log('query[0].SalesContract', query[0].SalesContract)
                //Check if contract is present
                if (query[0].SalesContract != '') {
                    updateStatus()
                }
                else {
                    req.error(406, 'For Request ' + query[0].requestNoConcat + ', contract details are missing for Business Partner ' + query[0].businessPartner + '.')
                }
            }
            else if (queryStatus[0].rStatus == 'NWLREQ' || queryStatus[0].rStatus == 'WLRQTD' || queryStatus[0].rStatus == 'NWLREC' || queryStatus[0].rStatus == 'NWLSCR' || queryStatus[0].rStatus == 'NWLVAL' || queryStatus[0].rStatus == 'WLCRTD' || queryStatus[0].rStatus == 'AWLREC') {
                updateStatus()
            }
        }
        else if (query[0].to_requestStatus_rStatus == 'APRRDY' && queryStatus[0].rStatus != 'MRAPRD' && queryStatus[0].rStatus != 'APRRDY' && queryStatus[0].rStatus != 'NWLREQ' && queryStatus[0].rStatus != 'WLRQTD' && queryStatus[0].rStatus != 'NWLREC' && queryStatus[0].rStatus != 'NWLSCR' && queryStatus[0].rStatus != 'NWLVAL' && queryStatus[0].rStatus != 'WLCRTD' && queryStatus[0].rStatus != 'AWLREC') {
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only proceed to next status ' + queryStatusDisp[9].rStatusDesc + ' and to previous statuses.')
        }
        else if (query[0].to_requestStatus_rStatus == 'APRRDY' && queryStatus[0].rStatus == 'APRRDY')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = Approved & Selected Status = Task List Identified
        else if (query[0].to_requestStatus_rStatus == 'MRAPRD' && queryStatus[0].rStatus == 'TLIDNT') {
            var queryWorkItem = await tx1.read('WorkItems').where({ requestNo: query[0].requestNo })
            var array = new Array()
            for (var i = 0; i < queryWorkItem.length; i++) {
                console.log('queryWorkItem[i].taskListFlag', queryWorkItem[i].taskListFlag)
                array[i] = queryWorkItem[i].taskListFlag
                //If any of the workitem doesnot have tasklist it will give a error msg
                if (array.includes(false) && queryWorkItem[i].taskListFlag == false) {
                    req.error(406, 'For Request ' + query[0].requestNoConcat + ' Task List is not identified for WorkItem ' + queryWorkItem[i].workItemID)
                }
                else {
                    updateStatus()
                    //update the status to task list identified and enable the Revision Create button
                    await UPDATE(MaintenanceRequests).set({
                        updateRevisionFlag: true
                    }).where({ ID: id1 })
                }
            }
        }
        else if (query[0].to_requestStatus_rStatus == 'MRAPRD' && queryStatus[0].rStatus != 'TLIDNT' && queryStatus[0].rStatus != 'MRAPRD')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only proceed to next status ' + queryStatusDisp[10].rStatusDesc)
        else if (query[0].to_requestStatus_rStatus == 'MRAPRD' && queryStatus[0].rStatus == 'MRAPRD')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = Task List Identified & Selected Status is not equal to task list identified -> then it will give error msg that Revision is required
        else if (query[0].to_requestStatus_rStatus == 'TLIDNT' && queryStatus[0].rStatus != 'TLIDNT')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and Revision is required to proceed further.')
        else if (query[0].to_requestStatus_rStatus == 'TLIDNT' && queryStatus[0].rStatus == 'TLIDNT')
            req.error(406, 'Request is already in status ' + query[0].to_requestStatus_rStatusDesc)

        //MR Status = Revision Created & selected status = Notifications Created
        else if (query[0].to_requestStatus_rStatus == 'RVCRTD' && queryStatus[0].rStatus == 'NTCRTD') {
            var queryWorkItem = await tx1.read('WorkItems').where({ requestNo: query[0].requestNo })
            var array1 = new Array()
            for (var i = 0; i < queryWorkItem.length; i++) {
                console.log('queryWorkItem[i].notificationFlag', queryWorkItem[i].notificationFlag)
                array1[i] = queryWorkItem[i].notificationFlag
                //If any of the workitem doesnot have notification it will give a error msg
                if (array1.includes(false)) {
                    req.error(406, 'For Request ' + query[0].requestNoConcat + ' Notification is not generated for WorkItem ' + queryWorkItem[i].workItemID)
                }
                else {
                    updateStatus()
                }
            }
        }
        else if (query[0].to_requestStatus_rStatus == 'RVCRTD' && queryStatus[0].rStatus != 'NTCRTD' && queryStatus[0].rStatus != 'RVCRTD')
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only proceed to next status ' + queryStatusDisp[12].rStatusDesc)
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
            req.error(406, 'For Request ' + query[0].requestNoConcat + ' current status is ' + query[0].to_requestStatus_rStatusDesc + ' and can only proceed to next status ' + queryStatusDisp[13].rStatusDesc)
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
        const id1 = req.params[0].ID
        const tx1 = cds.transaction(req)
        var queryStatus = await tx1.read(RequestStatusesDisp).where({ rStatus: 'RVCRTD' })
        console.log('queryStatus', queryStatus)
        var queryPhase = await tx1.read(RequestPhases).where({ rPhase: 'MRPREP' })
        console.log('queryPhase', queryPhase)
        var query = await tx1.read(MaintenanceRequests).where({ ID: id1 })
        console.log('query', query)
        //IF Revision is selected from Revision VH on object Page
        //Then Status will get Updated after clicking "Create Revision"
        if (query[0].MaintenanceRevision != null) {
            await UPDATE(MaintenanceRequests).set({
                to_requestStatus_rStatus: 'RVCRTD',
                to_requestStatus_rStatusDesc: 'Revision Created',
                to_requestStatusDisp_rStatus: 'RVCRTD',
                to_requestStatusDisp_rStatusDesc: 'Revision Created',
                to_requestPhase_rPhase: 'MRPREP',
                to_requestPhase_rPhaseDesc: 'Preparation',
                updateRevisionFlag: false
            }).where({ ID: id1 })
        }
        else {
            //When the Status is Task List Identified
            if (query[0].to_requestStatus_rStatus == 'TLIDNT') {

                //Fetching planning plant, request desc, work center and arrival and delivery date for performing POST request to MaintRevision S4 Service
                //Mandatory fields for creating a revision
                if (reqwcPlant == null) {
                    vplanningPlant = query[0].MaintenancePlanningPlant
                }
                else {
                    vplanningPlant = reqwcPlant
                }

                //Revision text will contain Request Number + Type + Material + Serial Number
                //If null value will be there is serial number or material then will not pass those fields in revision Description
                if (query[0].eqMaterial == null && query[0].eqSerialNumber == null) {
                    vrevisionText = query[0].requestNo + ' ' + query[0].to_requestType_rType
                } else if (query[0].eqMaterial == null && query[0].eqSerialNumber != null) {
                    vrevisionText = query[0].requestNo + ' ' + query[0].to_requestType_rType + ' ' + query[0].eqSerialNumber
                }
                else if (query[0].eqMaterial != null && query[0].eqSerialNumber == null) {
                    vrevisionText = query[0].requestNo + ' ' + query[0].to_requestType_rType + ' ' + query[0].eqMaterial
                }
                else {
                    vrevisionText = query[0].requestNo + ' ' + query[0].to_requestType_rType + ' ' + query[0].eqMaterial + ' ' + query[0].eqSerialNumber
                }

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
                vrevisionStartDate = query[0].expectedArrivalDate
                var vexpectedDeliveryDate = new Date(query[0].expectedDeliveryDate)
                var vformatedexpectedDeliveryDate = '/Date(' + vexpectedDeliveryDate.getTime() + ')/'
                vrevisionEndDate = query[0].expectedDeliveryDate
                vfunctionalLocation = query[0].functionalLocation
                vequipment = query[0].equipment

                //Revision will trigger when requestphase will change from intial to planning
                //One request should always have 1 MR
                if (query[0].MaintenanceRevision == null) {
                    try {
                        if (vplanningPlant != null && vrevisionText != null && vworkCenter != null && vworkCenterPlant != null && vrevisionStartDate != null && vrevisionEndDate != null) {
                            const tx = service2.tx(req)
                            var data = {
                                "PlanningPlant": vplanningPlant,
                                "RevisionType": 'A1',
                                "RevisionText": vrevisionText,
                                "WorkCenter": vworkCenter,
                                "WorkCenterPlant": vworkCenterPlant,
                                "RevisionStartDate": vformatexpectedArrivalDate,
                                "RevisionEndDate": vformatedexpectedDeliveryDate
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
                                    console.log('data', data)
                                    var result = await tx.send({ method: 'POST', path: 'MaintRevision', data })
                                } catch (error) {
                                    //If floc and equip are not in parent-child relation then floc will pass to create a revision
                                    //Err- Either select floc or equip
                                    //Will pass the Floc and delete the equip from payload
                                    delete data.Equipment
                                    console.log('data', data)
                                    var result = await tx.send({ method: 'POST', path: 'MaintRevision', data })
                                    await UPDATE(MaintenanceRequests).set({
                                        equipment: null,
                                        equipmentName: null
                                    }).where({ ID: id1 })
                                }
                            }
                            console.log('Revision', result)
                            await UPDATE(MaintenanceRequests).set({
                                //revision: result.RevisionNo,
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
                            req.notify(201, 'For Request ' + query[0].requestNoConcat + ' Revision ' + result.RevisionNo + ' has been created.')
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
        }
    });

    //Handler for Calculate Ageing
    this.on('calculateAgingFunc', async (req) => {
        var query = await SELECT.from(MaintenanceRequests).columns('*')
        var query1 = await SELECT.from(Ranges).columns('*')
        for (let i = 0; i < query.length; i++) {

            var rangeID, range, age;
            var currentDate = new Date()
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

    //Handler for change document status and it is handled by a BOT 
    //When New excel is in correct format then we used this function to change document status etc.
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

    //Handler for Creating the WorkItem
    this.before('CREATE', 'WorkItems', async (req) => {
        //Insert and update restrictions using hidden criteria
        req.data.uiHidden = true  //Hide the requestNo field after create
        req.data.uiHidden1 = false //Unhiede the requestNoDisp field after create
        var query = await SELECT.from(MaintenanceRequests).columns('*').where({ requestNo: req.data.requestNo })
        if (query[0].to_requestStatusDisp_rStatus != 'NWLVAL') {
            req.error(406, 'Work item cannot be created as current status of Request ' + req.data.requestNo + ' is ' + query[0].to_requestStatusDisp_rStatusDesc + '.');
        }

        //Generating the WorkItem number from Number Range service
        var query = await SELECT.from(WorkItemTypes).columns('*')
        console.log('query', query)
        var query1 = await service1.read(NumberRanges).columns('*').where({ numberRangeID: query[0].workItemType })
        req.data.to_to_workItemType_workItemType = query[0].workItemType
        console.log('req.data.to_to_workItemType_workItemType', req.data.to_to_workItemType_workItemType)
        console.log('query1', query1)
        if (query1[0] != null) {
            const nrID = await service1.getLastRunningNumber(query1[0].numberRangeID)
            req.data.workItemID = nrID
            console.log('req.data.workItem', req.data.workItemID)
            //vnumberRangeID = query1[i].numberRangeID 
        } else {
            req.error(406, req.data.to_to_workItemType_workItemType + ' ID is not present in Number Range.')
        }
    })

    //Handler for creating and updating the workItem
    this.before(['CREATE', 'UPDATE'], 'WorkItems', async (req) => {

        if (req.data.MaintenanceNotification == '')
            req.data.notificationFlag = false
        else if (req.data.MaintenanceNotification != null) {
            req.data.notificationFlag = true;
        }

        //If the task list is assign to the workitem , the flag will set as true
        if (req.data.taskListType != null && req.data.taskListGroup != null && req.data.taskListGroupCounter != null) {
            if (req.data.taskListType == '' && req.data.taskListGroup == '' && req.data.taskListGroupCounter == '') {
                req.data.taskListDescription = null
                req.data.documentNo = null
                req.data.documentVersion = null
                req.data.taskListFlag = false
                req.data.assignTaskListFlag = true
                req.data.multiTaskListFlag = null
            }
            else if (req.data.taskListType == '' && req.data.taskListGroup == '') {
                req.error(401, 'Task List Type and Task List Group is empty.')
            }
            else if (req.data.taskListType == '' && req.data.taskListGroupCounter == '') {
                req.error(401, 'Task List Type and Task List Group Counter is empty.')
            }
            else if (req.data.taskListGroup == '' && req.data.taskListGroupCounter == '') {
                req.error(401, 'Task List Group and Task List Group Counter is empty.')
            }
            else if (req.data.taskListType == '') {
                req.error(401, 'Task List Type is empty.')
            }
            else if (req.data.taskListGroup == '') {
                req.error(401, 'Task List Group is empty.')
            }
            else if (req.data.taskListGroupCounter == '') {
                req.error(401, 'Task List Group Counter is empty.')
            }
            else {
                req.data.taskListFlag = true;
                req.data.assignTaskListFlag = false;
                req.data.multiTaskListFlag = false;
            }
        }
        else {
            req.data.taskListFlag = false
            req.data.assignTaskListFlag = true
        }

        if (req.data.MaintenanceNotification != null) {//11000000
            req.data.notificationUpdateFlag = true;//update enable
            req.data.notificationGenerateFlag = false
        }
        else {
            req.data.notificationGenerateFlag = true;//disable
            req.data.notificationUpdateFlag = false
        }

        //It will fetch the previsous detail of tasklist.
        var queryWorkItem1 = await SELECT.from(WorkItems).columns('*').where({ ID: req.data.ID })
        if (queryWorkItem1[0] != null) {
            //If tasklist is not equal or it gets modified then it will fetch modified date of tasklist
            if (req.data.taskListType != queryWorkItem1[0].taskListType || req.data.taskListGroup != queryWorkItem1[0].taskListGroup || req.data.taskListGroupCounter != queryWorkItem1[0].taskListGroupCounter || req.data.taskListDescription != queryWorkItem1[0].taskListDescription) {
                req.data.taskListIdentifiedDate = returnDate(new Date());
                if (req.data.taskListType == '' || req.data.taskListGroup == '' || req.data.taskListGroupCounter == '') {
                    req.data.taskListIdentifiedDate = null
                }
            }
        }
        else {
            if (req.data.taskListType != null) {
                req.data.taskListIdentifiedDate = returnDate(new Date());
            }
        }

        req.data.requestNoDisp = req.data.requestNo
        req.data.requestNoConcat = req.data.requestNo
    });

    //Handler for Create notification Action
    this.on('createNotification', async (req) => {

        for (let i = 0; i < req.params.length; i++) {
            console.log('length of req.param', req.params.length)
            const id1 = req.params[i].ID
            console.log('id1', id1)
            const tx1 = cds.transaction(req)

            var query = await tx1.read(WorkItems).where({ ID: id1 })
            console.log('query.........', query)

            var query1 = await tx1.read(MaintenanceRequests).where({ requestNo: query[i].requestNo })
            console.log('query1', query1)

            /* /Date(1224043200000)/ */
            var vexpectedArrivalDate = new Date(query1[i].expectedArrivalDate)
            var vformatedexpectedArrivalDate = '/Date(' + vexpectedArrivalDate.getTime() + ')/'
            console.log('vformatedexpectedArrivalDate', vformatedexpectedArrivalDate)

            var shortTaskDescription = query[i].requestNo + ' | ' + query[i].taskDescription;
            shortTaskDescription = shortTaskDescription.substring(0, 39); //Notification text length - 40 character
            console.log('shortTaskDescription value =', shortTaskDescription)

            var vNotificationLongTextCreate = query[i].requestNo + ' | ' + query[i].mrequestType + ' | ' + query[i].workOrderNo + ' | ' + query[i].sequenceNo + ' | ' + query[i].taskDescription
            console.log('vNotificationLongText', vNotificationLongTextCreate)

            try {
                if (query[i].MaintenanceNotification == null || query[i].MaintenanceNotification == '') {
                    //When Status is Revision Created
                    if (query1[0].to_requestStatusDisp_rStatus == 'RVCRTD') {

                        const tx = service2.tx(req)

                        var data = {
                            "NotificationText": shortTaskDescription,//MR no. + task descr
                            "NotificationType": 'M1',
                            "RequiredStartDate": vformatedexpectedArrivalDate,//Expected Arrival Date from MR
                            "MaintenanceRevisionWPS": query1[0].MaintenanceRevision,//From MR
                            "MaintenancePlanningPlant": query1[0].MaintenancePlanningPlant,//From MR
                            "WorkCenter": query1[0].locationWC,//From MR
                            "MaintenanceWorkCenterPlant": query1[0].MaintenancePlanningPlant,//From MR
                            "Equipment": query1[0].equipment,//From MR
                            "FunctionalLocation": query1[0].functionalLocation,//From MR
                            "NotificationLongTextCreate": vNotificationLongTextCreate,//MRNO + MR Type + WorkOrderNo + Sequence No + Task Description
                            "TaskListType": query[i].taskListType,
                            "TaskListGroup": query[i].taskListGroup,
                            "TaskListGroupCounter": query[i].taskListGroupCounter
                        }
                        console.log('data', data)
                        var result = await tx.send({ method: 'POST', path: 'MaintNotification', data })
                        console.log('result.MaintenanceNotification value', result.MaintenanceNotification)
                        console.log('result', result)

                        console.log('vID in post', query[i].ID)
                        const affectedRows = await UPDATE(WorkItems).set({
                            MaintenanceNotification: result.MaintenanceNotification,
                            NotificationType: result.NotificationType,
                            //notificationNoDisp: result.MaintenanceNotification,
                            notificationFlag: true,
                            notificationGenerateFlag: false
                        }).where({ ID: query[i].ID })
                        req.notify(201, 'For Work Item ' + query[i].workItemID + ' Notification ' + result.MaintenanceNotification + ' has been generated.')
                        console.log('affectedRows', affectedRows)
                    }
                    else
                        req.error(406, 'For Request ' + query[i].requestNo + ' current status is  ' + query1[0].to_requestStatusDisp_rStatusDesc + '. Revision is required to generate notification.')
                }
                else {
                    req.error(406, 'Notification already been created for Work Item ' + query[i].workItemID + '.')
                }

            } catch (error) {
                console.log('Status code -----------', error.statusCode)
                console.log('innererror  -----------', error.innererror.response.body.error.message.value)
                var vstatusCode = error.statusCode
                var verrorMessage = error.innererror.response.body.error.message.value
                req.error(406, 'Error Code : ' + vstatusCode + ' Error Message : ' + verrorMessage + '.')
            }
        }
    })

    //Handler for Assign Tasklist
    this.on('assignTaskList', async (req) => {
        for (let i = 0; i < req.params.length; i++) {
            console.log('length of req.param', req.params.length)
            const id1 = req.params[i].ID
            console.log('id1', id1)
            const tx1 = cds.transaction(req)

            var query = await tx1.read(WorkItems).where({ ID: id1 })
            console.log('query.........', query)

            var query2 = await SELECT.from(MaintenanceRequests).columns('*').where({ requestNo: query[i].requestNo })
            console.log('query2', query2)

            if (query[0].taskListType == null || query[0].taskListType == '') {
                var count = 0;
                var query1 = await service2.read(ReferenceTaskListVH).where({ ExternalReference: query[0].genericRef, ExternalCustomerReference: query[0].customerRef, Plant: query2[0].MaintenancePlanningPlant })

                //.length function is not supportive in HANA DB, So to resolve that use count
                query1.forEach(_ => count++)
                console.log('count', count)
                //When count is more thn 1 means multiple tasklist is identified.
                if (count > 1) {
                    req.notify(101, 'For Work Item ' + query[0].workItemID + ' there is multiple Task List identified.')

                    await UPDATE(WorkItems).set({
                        multiTaskListFlag: true
                    }).where({ ID: query[i].ID })
                }
                else if (count < 1) {
                    //When Count is less than 1 means no tasklist is indentified
                    req.info(101, 'For Work Item ' + query[0].workItemID + ' there is no Task List identified.')
                }
                else {
                    await UPDATE(WorkItems).set({
                        taskListType: query1[0].TaskListType,
                        taskListGroup: query1[0].TaskListGroup,
                        taskListGroupCounter: query1[0].TaskListGroupCounter,
                        taskListDescription: query1[0].TaskListDesc,
                        documentNo: query1[0].DocumentInfoRecordDocNumber,
                        documentVersion: query1[0].DocumentInfoRecordDocVersion,
                        taskListFlag: true,
                        assignTaskListFlag: false,
                        taskListIdentifiedDate: returnDate(new Date())
                    }).where({ ID: query[i].ID })
                    req.notify(201, 'For Work Item ' + query[i].workItemID + ' Task List has been assigned.')
                }
            }
            else {
                req.info(101, 'Task List is already assigned to Work Item ' + query[0].workItemID + '.')
            }
        }
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

    //Handler for checking uniqueness in the RequestTypeConfig
    this.before(['CREATE', 'UPDATE'], 'RequestTypeConfig', async (req) => {
        var vreqType = req.data.requestType;
        var vcount = 0;
        //Get transaction of the request
        const tx = cds.transaction(req);
        //Check if there another record with same requestType
        let result = await tx.read(RequestTypeConfig).where({ requestType: vreqType });
        console.log('result', result);
        result.forEach(_ => vcount++);
        console.log('count', vcount);
        //To check if the current record is not considered in edit mode
        if (vcount > 0 && req.data.ID != result[0].ID) {

            var vnotifType = result[0].notificationType;
            console.log('notification Type', vnotifType);
            req.error(406, vreqType + ' request type is already mapped to ' + vnotifType + ' notification type');
        }

        //Code for assigning bow type
        var vnotifType = req.data.notificationType;
        //Get transaction of the request
        //const tx = cds.transaction(req);
        //query for getting the related bowtype.
        let query = await tx.read(NotificationTypes).where({ notifType: vnotifType });
        var vbowType = query[0].bowType;
        console.log('bowType', vbowType);
        //assigning bowType
        req.data.bowType = vbowType;
        req.data.bowTypeDesc = query[0].bowTypeDesc
    });

    //Handler for create of Bill of Work Application
    this.before('CREATE', 'BillOfWorks', async (req) => {

        //Storing the values in database, after making all these fields as a readonly field
        var query = await SELECT.from(MaintenanceRequests).columns('*').where({ requestNo: req.data.requestNoConcat })
        console.log('query', query)
        req.data.requestType = query[0].to_requestType_rType
        req.data.businessPartner = query[0].businessPartner
        req.data.businessPartnerName = query[0].businessPartnerName
        req.data.SalesContract = query[0].SalesContract
        req.data.contractName = query[0].contractName
        req.data.MaintenanceRevision = query[0].MaintenanceRevision
        req.data.revisionText = query[0].revisionText
        req.data.workLocation = query[0].locationWC
        req.data.workLocationDetail = query[0].locationWCDetail
        req.data.MaintenancePlanningPlant = query[0].MaintenancePlanningPlant
        req.data.plantName = query[0].plantName
        req.data.expectedArrivalDate = query[0].expectedArrivalDate
        req.data.expectedDeliveryDate = query[0].expectedDeliveryDate
        req.data.functionalLocation = query[0].functionalLocation
        req.data.functionalLocationName = query[0].functionalLocationName
        req.data.equipment = query[0].equipment
        req.data.equipmentName = query[0].equipmentName

        //Bow Desc is Request Number + Request Type
        req.data.bowDesc = req.data.requestNoConcat + ' ' + query[0].to_requestType_rType

        //Storing Bow type based on request Type from Request Type config screen
        var query1 = await SELECT.from(RequestTypeConfig).columns('*').where({ requestType: query[0].to_requestType_rType })
        console.log('query1', query1)
        if (query1[0] != null) {
            req.data.bowType = query1[0].bowType
            req.data.bowTypeDesc = query1[0].bowTypeDesc
        }
        else {
            req.error(406, 'Request Type is not present in Request Type Config')
        }

        //Storing the values of distribution channel and devision in db after making it as readonly field
        if (req.data.salesOrganization) {
            var vsalesOrg = await service3.read(SalesOrgVH).columns('*').where({ SalesOrganization: req.data.salesOrganization })
            console.log('vsalesOrg', vsalesOrg)
            req.data.distributionChannel = vsalesOrg[0].DistributionChannel
            req.data.division = vsalesOrg[0].Division
        }

        //Storing the values of standardProject in db after making it as readonly field
        if (req.data.serviceProduct) {
            var vstandardProduct = await service5.read(ServiceProducts).columns('*').where({ Servicematerial: req.data.serviceProduct })
            console.log('vstandardProduct', vstandardProduct)
            req.data.standardProject = vstandardProduct[0].Project
        }

        //performig post operation to create BOW in create handler
        const tx = cds.transaction(req)
        const tx1 = service4.tx(req)
        var data = {
            "bowty": req.data.bowType,
            "Bowtxt": req.data.bowDesc,
            "MaintenanceRevision": req.data.MaintenanceRevision,
            "MaintenancePlanningPlant": req.data.MaintenancePlanningPlant,
            "vkorg": req.data.salesOrganization,
            "vtweg": req.data.distributionChannel,
            "spart": req.data.division,
            "Mainworkcenter": req.data.workLocation,
            "werks": req.data.MaintenancePlanningPlant,
            "Servicematerial": req.data.serviceProduct,
            "Standardproject": req.data.standardProject,
            "kunag": req.data.businessPartner,
            "CustomerName": req.data.businessPartnerName,
            "Documentcurrency": req.data.currency,
            "bstnk": "",
            "SalesContract": req.data.SalesContract,
            "CopyWorklist": "",
            "Eventdata": ""
        }
        var result = await tx1.send({ method: 'POST', path: 'xHCLPRODSxC_Bow', data })
        console.log('result', result)
    });

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