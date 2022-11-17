namespace com.hcl.mro.requestdolphin;

using {
    managed,
    sap.common,
} from '@sap/cds/common';

entity MaintenanceRequests : managed {
    key ID                               : UUID                                                                         @title                 : '{i18n>ID}'                    @Core.Computed; //unique ID for Maintenace request
        requestNo                        : String                                                                       @title                 : '{i18n>requestNo}'; // will generate after selecting request type
        requestNoConcat                  : String                                                                       @Common.SemanticObject : 'MaintenanceRequest'           @title                                           : '{i18n>requestNo}';
        requestDesc                      : String                                                                       @title                 : '{i18n>requestDesc}'; // maintenance request Description
        businessPartner                  : String                                                                       @title                 : '{i18n>businessPartner}'; //bp service from s4
        businessPartnerDisp              : String                                                                       @title                 : '{i18n>businessPartner}'; // bp to be display on only list report page to perform filteration
        businessPartnerName              : String                                                                       @title                 : '{i18n>businessPartnerName}'; //autopopulate after selecting business partner
        businessPartnerNameDisp          : String                                                                       @title                 : '{i18n>businessPartnerName}'; //bp name to be display on list report page so that user see bp name after selecting bp from selection
        bpConcatenation                  : String; //Concatenated BP value 101(Boeing Ltd.) used in ovp card of Busines partner
        soldToParty                      : String                                                                       @title                 : 'soldToParty';
        eqMaterial                       : String                                                                       @title                 : '{i18n>eqMaterial}'; //Equipment Material
        eqSerialNumber                   : String                                                                       @title                 : '{i18n>eqSerialNumber}'; //Equipment serial number
        equipment                        : String                                                                       @title                 : '{i18n>equipment}'; // Equipment VH having filterable property(Material and serial number)
        equipmentName                    : String                                                                       @title                 : '{i18n>equipmentName}'; //equipment name will display after selecting equipment
        locationWC                       : String                                                                       @title                 : '{i18n>locationWC}'; //workcenter
        locationWCDetail                 : String                                                                       @title                 : '{i18n>locationWCDetail}'; //work center Detail(Work Center Name)
        MaintenancePlanningPlant         : String                                                                       @title                 : '{i18n>MaintenancePlanningPlant}'; //workcenter plant = planning plant
        plantName                        : String                                                                       @title                 : '{i18n>plantName}'; //Plant Description
        SalesContract                    : String                                                                       @Common.SemanticObject : 'SalesContract'                @title                                           : '{i18n>contract}'; // Contracts assosiated with BP (contract no, desc and Turn around time)
        contractName                     : String                                                                       @title                 : '{i18n>contractName}'; //contract name will auto populate after selcting right contract
        expectedArrivalDate              : Date                                                                         @title                 : '{i18n>expectedArrivalDate}'; //System current date
        expectedDeliveryDate             : Date                                                                         @title                 : '{i18n>expectedDeliveryDate}'; //System current date and user can change date-turn around time from contract s4 service will be stored in expected delivery date
        startDate                        : Date                                                                         @title                 : '{i18n>startDate}'; //System current date
        endDate                          : Date                                                                         @title                 : '{i18n>endDate}'; //System current date
        mName                            : String                                                                       @title                 : '{i18n>mName}'; //Manufacturer Name
        mModel                           : String                                                                       @title                 : '{i18n>mModel}'; //Manufacturer Model
        mSerialNumber                    : String                                                                       @title                 : '{i18n>mSerialNumber}'; //Manufacturer Serial Number
        mPartNumber                      : String                                                                       @title                 : '{i18n>mPartNumber}'; //Manufacturer Part Number
        functionalLocation               : String                                                                       @title                 : '{i18n>functionalLocation}'; //VH for fucntional location s4 service with filter criteria(mname,mmodel and mserialNumber)
        functionalLocationName           : String                                                                       @title                 : '{i18n>functionalLocationName}'; //readonly field for functional location
        MaintenanceRevision              : String                                                                       @Common.SemanticObject : 'MaintenanceRevisionOverview'  @title                                           : '{i18n>MaintenanceRevision}'; // create by trigerring when request status is confirmed
        revisionType                     : String                                                                       @title                 : '{i18n>revisionType}'; // It will hold the value as A1
        revisionText                     : String                                                                       @title                 : '{i18n>revisionText}'; // concatenation of request Number and request Ddescription
        ccpersonName                     : String                                                                       @title                 : '{i18n>ccpersonName}'          @UI.Placeholder                                  : 'Name'; //free text field comes from BP
        ccemail                          : String                                                                       @title                 : '{i18n>ccemail}'               @UI.Placeholder                                  : 'E-Mail'; //free text field comes from BP
        ccphoneNumber                    : String                                                                       @title                 : '{i18n>ccphoneNumber}'         @UI.Placeholder                                  : 'Telephone Number'; //free text field comes from BP
        criticalityLevel                 : Integer; //It will decide the color combination of Request status and Request phase
        emailFlag                        : Boolean; //True indicates -> mail sent & false indicates -> mail not sent
        uiHidden                         : Boolean not null default false; //datafield to apply hidden criteria for request type and request status
        uiHidden1                        : Boolean not null default true; //datafield to apply hidden criteria for request type and request status
        requestTypeDisp                  : String                                                                       @title                 : '{i18n>requestTypeDisp}'; //to assign the request type at the time of edit and readonly field
        mrCount                          : Integer default 1                                                            @title                 : '{i18n>mrCount}'; //Used in views to show count of the requests
        createdAtDate                    : Date                                                                         @cds.on.insert         : $now                           @title                                           : '{i18n>createdAtDate}'; //Used as a filter criteria for Overview page(Date DataType works as a date picker)
        age                              : Integer default 0                                                            @title                 : '{i18n>age}'; //For representing Aging field
        changeStatusFlag                 : Boolean not null default false                                               @title                 : '{i18n>changeStatusFlag}'; //For Change Status Action - Disable action at the time of create
        updateRevisionFlag               : Boolean not null default false                                               @title                 : '{i18n>updateRevisionFlag}'; //For Update Revision Action - Disable action at the  time of create
        businessPartnerRole              : String                                                                       @title                 : '{i18n>businessPartnerRole}'; //Business Partner as role
        to_requestType                   : Association to RequestTypes                                                                                                          @title : '{i18n>requestType}'  @assert.integrity : false; //as dropdown - request number will generate through request type
        to_requestStatus_rStatus         : String                                                                       @title                 : '{i18n>requestStatus}'; //Physical field for status on object page- unmanged association
        to_requestStatus_rStatusDesc     : String                                                                       @title                 : '{i18n>requestStatus}'; //Physical field for statusDesc - unmanged association
        to_requestStatus                 : Association to RequestStatuses
                                               on  to_requestStatus.rStatus     = to_requestStatus_rStatus
                                               and to_requestStatus.rStatusDesc = to_requestStatus_rStatusDesc          @assert.integrity      : false; //At the time of create Request status is draft And at the time of edit,from dropdown request status can change from Draft to confirmed
        to_requestStatusDisp_rStatus     : String                                                                       @title                 : '{i18n>requestStatus}'; //Physical field for status on object page- unmanged association
        to_requestStatusDisp_rStatusDesc : String                                                                       @title                 : '{i18n>requestStatus}'; //Physical field for status Desc on object page- unmanged association
        to_requestStatusDisp             : Association to RequestStatusesDisp
                                               on  to_requestStatusDisp.rStatus     = to_requestStatusDisp_rStatus
                                               and to_requestStatusDisp.rStatusDesc = to_requestStatusDisp_rStatusDesc  @title                 : '{i18n>requestStatus}'         @assert.integrity                                : false; //Status filter on List Report page
        to_requestPhase_rPhase           : String                                                                       @title                 : '{i18n>requestPhase}'; //Physical field for phase on object page and list page- unmanged association - auto poulate with status change
        to_requestPhase_rPhaseDesc       : String                                                                       @title                 : '{i18n>requestPhase}'; //Physical field for phase desc on object page and list page - unmanged association - auto populate with status change
        to_requestPhase                  : Association to RequestPhases
                                               on  to_requestPhase.rPhase     = to_requestPhase_rPhase
                                               and to_requestPhase.rPhaseDesc = to_requestPhase_rPhaseDesc              @assert.integrity      : false; //at create = initial// Phase filter on List page
        to_document                      : Composition of many Documents
                                               on to_document.to_maintenanceRequest = $self                             @title                 : '{i18n>document}'; //One to many (1 MR - multiple documents links) i.e. Attaching multiple url w.r.t. MR
        to_ranges                        : Association to Ranges                                                                                                                @title : '{i18n>range}'  @assert.integrity       : false; //Age Range (0-30,30-60,...)
        to_workItems                     : Association to many WorkItems
                                               on to_workItems.requestNo = $self.requestNo; //One to many association to WorkItems based on request Number
        to_billOfWorks                   : Association to many BillOfWorks
                                               on to_billOfWorks.requestNoConcat = $self.requestNo; //One to many association to Bill of Works based on request number
};

entity RequestTypes {
    key rType : String;
};

//It is used in change status action button as a drop down on Object Page
entity RequestStatuses {
    key ID          : Integer;
    key rStatus     : String;
    key rStatusDesc : String;
        to_rPhase   : Association to RequestPhases;
};

//It is used as Status drop down on list report page for display purpose
entity RequestStatusesDisp {
    key ID          : Integer;
    key rStatus     : String;
    key rStatusDesc : String;
};

//It will auto populate after changing Status
entity RequestPhases {
    key ID         : Integer;
    key rPhase     : String;
    key rPhaseDesc : String;
};

entity WorkItems : managed {
    key ID                       : UUID                            @title                 : 'ID'                       @Core.Computed;
        workItemID               : Integer                         @title                 : 'Work Item'; //Generate the WorkItem number from Number Range service
        requestNo                : String                          @title                 : 'Maintenance Request'; //Maintenance Request No using on object page on create
        requestNoDisp            : String                          @title                 : 'Maintenance Request'; //Maintenance Request No using on object on edit
        requestNoConcat          : String                          @title                 : 'Maintenance Request'; // using list report page (RequestNo and RequestDescription)
        uiHidden                 : Boolean not null default false; //this field will be used at the time of create for requestNo
        uiHidden1                : Boolean not null default true; //this field will used at the time of edit (read only) for requestNoDisp
        sequenceNo               : String                          @title                 : 'Sequence Number'; //sequence Number
        requestDesc              : String                          @title                 : 'Maintenance Request Description'; // Maintenance Request Description
        mrequestType             : String                          @title                 : 'Maintenance Request Type'; //Maintenance Request Type
        planningPlant            : String                          @title                 : 'Work Location Plant'; //Planning Plant
        mrequestStatus           : String                          @title                 : 'Status'; //Maintenance Request Status
        estimatedDueDate         : Date                            @title                 : '{i18n>estimatedDueDate}'; //Estimated Due Date Used in BOT
        workOrderNo              : String                          @title                 : 'Work Order Number'; //Work Order
        customerRef              : String                          @title                 : 'Customer Reference'; //Customer Refrence
        taskDescription          : String                          @title                 : 'Description'; //Task Description
        MaintenanceNotification  : String                          @Common.SemanticObject : 'MaintenanceNotification'  @title                            : 'Notification'; //Notification No
        NotificationType         : String                          @title                 : 'Notification Type'; //Notification Type
        //notificationNoDisp       : String                         @title :                    'Notification'; //Displaying notification Number in notification VH in List report Page
        notificationFlag         : Boolean not null default false  @title                 : 'Notification Exists'      @readonly; //Notification Created Flag (Yes/No)
        notificationGenerateFlag : Boolean not null default false; // Notification action flag for enabling and disabling Generate Notification button
        notificationUpdateFlag   : Boolean not null default false; // Notification action flag for enabling and disabling Update Notification button
        additionalRemark         : String                          @UI.MultiLineText                                   @title                            : 'Additional Remarks'; //Additional Remarks
        documentID               : String                          @title                 : 'Document ID'; // Document ID
        genericRef               : String                          @title                 : 'Generic Reference'; //genericRef
        taskListGroup            : String                          @title                 : 'Task List Group'; //task List Group
        taskListGroupCounter     : String                          @title                 : 'Task List Group Counter'; //task List Group Counter
        taskListType             : String                          @title                 : 'Task List Type'; //task List Type
        taskListDescription      : String                          @title                 : 'Task List Description'; //task List Description
        documentNo               : String                          @title                 : 'Document Number'; // Auto populate from Task List Value Help
        documentType             : String                          @title                 : 'Document Type'; // Auto populate from Task List Value Help
        documentPart             : String                          @title                 : 'Document Part'; // Auto populate from Task List Value Help
        documentVersion          : String                          @title                 : 'Document Version'; //Auto Populate from Task List Value Help
        taskListFlag             : Boolean not null default false  @title                 : 'Task List Flag'; //Once the task list is created for workitem, the flag will set as true
        assignTaskListFlag       : Boolean not null default false  @title                 : 'Assign Task List Flag'; //Enable and disable of Assign tasklist button
        taskListIdentifiedDate   : Date                            @title                 : 'Task List Identified Date'; //When tasklist is identified it will capture the date
        multiTaskListFlag        : Boolean                         @title                 : 'Multiple Task List'; // Multi assign task list
        to_typeOfLoad            : Association to TypeOfLoads                                                          @assert.integrity : false  @title : 'Data Upload Process'; //Type Of Load
        to_maintenanceRequest    : Association to one MaintenanceRequests; //One to one association to MR
};

//Used to generate the WorkItem through workItem ID
entity WorkItemTypes {
    key workItemType : String;
};

//Data upload process(Not using)
entity TypeOfLoads {
    key ID       : Integer;
    key loadType : String; //type of load for data upload process
};

entity Documents : managed {
    key UUID                     : UUID                           @Core.Computed; //Unique ID as UUID
        ID                       : String                         @title : '{i18n>document_ID}'; //It got incremented by 1 w.r.t. MR
        url                      : String                         @title : '{i18n>document_url}'; //document url
        documentName             : String                         @title : '{i18n>documentName}'; //url decription
        eMailRecievedDateAndTime : DateTime                       @title : '{i18n>eMailRecievedDateAndTime}'; //E-Mail Recieved Date
        fileFormatCheckRequired  : Boolean not null default false @title : '{i18n>fileFormatCheckRequired}'; // File Format Check RequiredY/N.
        formatCheck              : Boolean not null default false @title : '{i18n>formatCheck}'; // Format Check Y/N.
        eMailSent                : Boolean not null default false @title : '{i18n>eMailSent}'; // Email Sent Y/N
        workItemsCreated         : Boolean not null default false @title : '{i18n>workItemsCreated}'; // WorkItems Created Y/N
        remarks                  : String                         @title : '{i18n>remarks}'; // Remarks
        to_documentStatus        : Association to DocumentStatuses  @assert.integrity : false  @title : '{i18n>to_documentStatus}'; //Association to DocumentStatuses Entity
        to_typeOfAttachment      : Association to AttachmentTypes   @assert.integrity : false  @title : '{i18n>to_typeOfAttachment}'; //Association to AttachmentTypes (file extension)
        to_maintenanceRequest    : Association to MaintenanceRequests; //one to one(1 document link - 1 MR)
};

//Statuses of Document (New Document, Validation Not Required, Validation done, Invalid Document, Document Processed)
entity DocumentStatuses {
    key ID            : Integer;
    key docStatus     : String;
    key docStatusDesc : String;
}

//Show the Attachment type (Excel or Others)
entity AttachmentTypes {
    key ID             : Integer;
    key attachmentType : String;
};

//Range will define the age of the request - Used in Overview page
entity Ranges {
    key ID    : Integer default 1;
    key range : String default '0-30';
};

//Request Type Config used in Admin Screen
// @assert.unique : {requestType : [requestType]}
entity RequestTypeConfig : managed {
    key ID               : UUID @Core.Computed;
        requestType      : String;
        notificationType : String;
        bowType          : String;
        bowTypeDesc      : String;
};

//Notification Type used in Admin Screen
entity NotificationTypes {
    key notifType   : String;
        bowType     : String;
        bowTypeDesc : String;
};

entity BillOfWorks : managed {
    key ID                       : UUID    @Core.Computed;
        requestNoConcat          : String  @Common.SemanticObject : 'MaintenanceRequest'   @title                 : 'Maintenance Request';
        requestNoDisp            : String  @Common.SemanticObject : 'MaintenanceRequest'   @title                 : 'Maintenance Request'; //Maintenance Request No using on object on edit
        uiHidden                 : Boolean not null default false; //this field will be used at the time of create for requestNo
        uiHidden1                : Boolean not null default true; //this field will used at the time of edit (read only) for requestNoDisp
        requestDesc              : String  @title                 : 'Request Description'; // maintenance request Description
        requestType              : String  @title                 : 'Maintenance Request Type';
        businessPartner          : String  @title                 : 'Business Partner';
        businessPartnerName      : String  @title                 : 'Business Partner Name';
        SalesContract            : String  @Common.SemanticObject : 'SalesContract'  @title                 : 'Contract';
        contractName             : String  @title                 : 'Contract name';
        MaintenanceRevision      : String  @Common.SemanticObject : 'MaintenanceRevisionOverview'   @title                 : 'Revision';
        revisionText             : String  @title                 : 'Revision Text';
        workLocation             : String  @title                 : 'Work Location';
        workLocationDetail       : String  @title                 : 'Work Location Detail';
        MaintenancePlanningPlant : String  @title                 : 'Work Location Plant';
        plantName                : String  @title                 : 'Plant Name';
        expectedArrivalDate      : Date    @title                 : 'Expected Arrival Date';
        expectedDeliveryDate     : Date    @title                 : 'Expected Delivery Date';
        functionalLocation       : String  @title                 : 'Functional Location';
        functionalLocationName   : String  @title                 : 'Functional Location Name';
        equipment                : String  @title                 : 'Equipment';
        equipmentName            : String  @title                 : 'Equipment Name';
        workOrderNo              : String  @title                 : 'Work Order Number';
        Bowid                    : String  @Common.SemanticObject : 'MaintenanaceBillOfWork'  @title : 'Bill of Work';
        bowType                  : String  @title                 : 'Bill of Work Type';
        bowTypeDesc              : String  @title                 : 'Bill of Work Type Description';
        bowDesc                  : String  @title                 : 'Bill of Work Description';
        currency                 : String  @title                 : 'Currency';
        salesOrganization        : String  @title                 : 'Sales Organization';
        distributionChannel      : String  @title                 : 'Distribution Channel';
        division                 : String  @title                 : 'Division';
        serviceProduct           : String  @title                 : 'Service Product';
        standardProject          : String  @title                 : 'Standard Project';
        to_maintenanceRequest    : Association to MaintenanceRequests;
};

//Configurations entity for Admin screen(Not using)
entity Configurations : managed {
    key ID                 : UUID                             @Core.Computed; //Unique ID
        manufacturerName   : Boolean; //Manufacturer Name
        manfuracterModel   : Boolean; //Manfuracter Model
        manurafacturerSl   : Boolean; //Manurafacturer Sl
        materialNo         : Boolean; //Material
        serialNo           : Boolean; //Serial
        to_requestType     : Association to RequestTypes      @assert.integrity : false;
        to_requestIndustry : Association to RequestIndustries @assert.integrity : false;
        to_schemaType      : Association to SchemaTypes       @assert.integrity : false;
};

//RequestIndustries for Admin Screen(Not using)
entity RequestIndustries {
    key rIndustry : String //Industry
};

//Schema Types for Admin Screen(Not using)
entity SchemaTypes {
    key sSchema : String //Search Schema
};

//Number of Request based on Request Statuses on Overview Page
@Aggregation.ApplySupported.PropertyRestrictions : true
view AggregatedMaintenanceReqOnStatuses as
    select from MaintenanceRequests {
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        createdAtDate,
        MaintenancePlanningPlant,
        locationWC,
        businessPartnerDisp,
        bpConcatenation,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    };

//Number of Request based on Request Phases on Overview Page
@Aggregation.ApplySupported.PropertyRestrictions : true
view AggregatedMaintenanceReqOnPhases as
    select from MaintenanceRequests {
        @Analytics.Dimension : true
        to_requestPhase_rPhaseDesc,
        createdAtDate,
        MaintenancePlanningPlant,
        locationWC,
        businessPartnerDisp,
        bpConcatenation,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    };

//Number of Request based on MR type(Complete Asset) which has wc on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view AggregatedReqByCompleteAssetAndWC as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        locationWC,
        businessPartnerDisp,
        bpConcatenation,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Complete Asset';

//Number of Request based on MR type(Component) which has wc on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view AggregatedReqByComponentAndWC as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        locationWC,
        businessPartnerDisp,
        bpConcatenation,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Component';

//Number of Request based on MR type(Assembly) which has wc on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view AggregatedReqByAssemblyAndWC as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        locationWC,
        businessPartnerDisp,
        bpConcatenation,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Assembly';

//Number of Request based on MR type(Complete Asset) which has BP on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view AggregatedReqByCompleteAssetAndBP as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        businessPartnerDisp,
        @Analytics.Dimension : true
        bpConcatenation,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Complete Asset';

//Number of Request based on MR type(Component) which has BP on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view AggregatedReqByComponentAndBP as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        businessPartnerDisp,
        @Analytics.Dimension : true
        bpConcatenation,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Component';

//Number of Request based on MR type(Assembly) which has BP on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view AggregatedReqByAssemblyAndBP as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        businessPartnerDisp,
        @Analytics.Dimension : true
        bpConcatenation,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Assembly';

//Number of Request based on MR type(Complete Asset) which has Ranges on x-axis and status on y-axis Created, Request for Work List, Requested Work List
@Aggregation.ApplySupported.PropertyRestrictions : true
view ReqByCompleteAssetAndRangeUntilRequestedWorkList as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        to_ranges,
        businessPartnerDisp,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Complete Asset'
        and (
               to_requestStatusDisp_rStatus = 'MRCRTD' //Created
            or to_requestStatusDisp_rStatus = 'NWLREQ' //Request for New Worklist
            or to_requestStatusDisp_rStatus = 'WLRQTD' //New Worklist Requested
        );

//Number of Request based on MR type(Assembly) which has Ranges on x-axis and status on y-axis Created, Request for Work List, Requested Work List
@Aggregation.ApplySupported.PropertyRestrictions : true
view ReqByAssemblyAndRangeUntilRequestedWorkList as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true //
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        to_ranges,
        businessPartnerDisp,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Assembly'
        and (
               to_requestStatusDisp_rStatus = 'MRCRTD' //Created
            or to_requestStatusDisp_rStatus = 'NWLREQ' //Request for New Worklist
            or to_requestStatusDisp_rStatus = 'WLRQTD' //New Worklist Requested
        );


//Number of Request based on MR type(Component) which has Ranges on x-axis and status on y-axis Created, Request for Work List, Requested Work List
@Aggregation.ApplySupported.PropertyRestrictions : true
view ReqByComponentAndRangeUntilRequestedWorkList as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        to_ranges,
        businessPartnerDisp,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Component'
        and (
               to_requestStatusDisp_rStatus = 'MRCRTD' //Created
            or to_requestStatusDisp_rStatus = 'NWLREQ' //Request for New Worklist
            or to_requestStatusDisp_rStatus = 'WLRQTD' //New Worklist Requested
        );

//Number of Request based on MR type(Complete Asset) which has Ranges on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view ReqByCompleteAssetAndRangeOverallStatus as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        to_ranges,
        businessPartnerDisp,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Complete Asset';


//Number of Request based on MR type(Assembly) which has Ranges on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view ReqByAssemblyAndRangeOverallStatus as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        to_ranges,
        businessPartnerDisp,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Assembly';


//Number of Request based on MR type(Component) which has Ranges on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view ReqByComponentAndRangeOverallStatus as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        to_ranges,
        businessPartnerDisp,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Component';

//Number of Request based on MR type(Complete Asset) which has Ranges on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view ReqByCompleteAssetAndRangeUntilNotifications as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        to_ranges,
        businessPartnerDisp,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Complete Asset'
        and (
               to_requestStatusDisp_rStatus = 'MRAPRD' //Approved
            or to_requestStatusDisp_rStatus = 'NTCRTD' //Notifications Created
        );

//Number of Request based on MR type(Assembly) which has Ranges on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view ReqByAssemblyAndRangeUntilNotifications as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        to_ranges,
        businessPartnerDisp,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Assembly'
        and (
               to_requestStatusDisp_rStatus = 'MRAPRD' //Approved
            or to_requestStatusDisp_rStatus = 'NTCRTD' //Notifications Created
        );

//Number of Request based on MR type(Component) which has Ranges on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view ReqByComponentAndRangeUntilNotifications as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        to_ranges,
        businessPartnerDisp,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Component'
        and (
               to_requestStatusDisp_rStatus = 'MRAPRD' //Approved
            or to_requestStatusDisp_rStatus = 'NTCRTD' //Notifications Created
        );

//Number of Request based on MR type(Complete Asset) which has Ranges on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view ReqByCompleteAssetAndRangePendingRevision as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        to_ranges,
        businessPartnerDisp,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Complete Asset'
        and (
            to_requestStatusDisp_rStatus = 'TLIDNT' //Task List Identified
        );

//Number of Request based on MR type(Assembly) which has Ranges on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view ReqByAssemblyAndRangePendingRevision as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        to_ranges,
        businessPartnerDisp,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Assembly'
        and (
            to_requestStatusDisp_rStatus = 'TLIDNT' //Task List Identified
        );

//Number of Request based on MR type(Component) which has Ranges on x-axis and status on y-axis
@Aggregation.ApplySupported.PropertyRestrictions : true
view ReqByComponentAndRangePendingRevision as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true
        to_requestStatusDisp_rStatusDesc,
        @Analytics.Dimension : true
        to_ranges,
        businessPartnerDisp,
        locationWC,
        createdAtDate,
        MaintenancePlanningPlant,
        @Analytics.Measure   : true
        @Aggregation.default : #SUM
        mrCount
    }
    where
        to_requestType.rType = 'Component'
        and (
            to_requestStatusDisp_rStatus = 'TLIDNT' //Task List Identified
        );
