namespace com.hcl.mro.requestdolphin;

using {
    managed,
    sap.common,
} from '@sap/cds/common';

entity MaintenanceRequests : managed {
    key ID                       : UUID                                             @title                 : '{i18n>ID}'  @Core.Computed; //unique ID for Maintenace request
        requestNo                : String                                           @title                 : '{i18n>requestNo}'; // will generate after selecting request type
        requestNoConcat          : String                                           @Common.SemanticObject : 'maintenancerequest'  @title              : '{i18n>requestNo}';
        requestDesc              : String                                           @title                 : '{i18n>requestDesc}'; // maintenance request Description
        businessPartner          : String                                           @title                 : '{i18n>businessPartner}'; //bp service from s4
        businessPartner1         : String                                           @title                 : '{i18n>businessPartner}'; // bp to be display on only list report page to perform filteration
        businessPartnerName      : String                                           @title                 : '{i18n>businessPartnerName}'; //autopopulate after selecting business partner
        businessPartnerName1     : String                                           @title                 : '{i18n>businessPartnerName}'; //bp name to be display on list report page so that user see bp name after selecting bp from selection
        bpConcatenation          : String; //Concatenated BP value 101(Boeing Ltd.) used in ovp card of Busines partner
        eqMaterial               : String                                           @title                 : '{i18n>eqMaterial}'; //Equipment Material
        eqSerialNumber           : String                                           @title                 : '{i18n>eqSerialNumber}'; //Equipment serial number
        equipment                : String                                           @title                 : '{i18n>equipment}'; // Equipment VH having filterable property(Material and serial number)
        equipmentName            : String                                           @title                 : '{i18n>equipmentName}'; //equipment name will display after selecting equipment
        locationWC               : String                                           @title                 : '{i18n>locationWC}'; //workcenter
        locationWCDetail         : String                                           @title                 : '{i18n>locationWCDetail}'; //work center Detail(Work Center Name)
        MaintenancePlanningPlant : String                                           @title                 : '{i18n>MaintenancePlanningPlant}'; //workcenter plant = planning plant
        contract                 : String                                           @title                 : '{i18n>contract}'; // Contracts assosiated with BP (contract no, desc and Turn around time)
        contractName             : String                                           @title                 : '{i18n>contractName}'; //contract name will auto populate after selcting right contract
        expectedArrivalDate      : Date                                             @title                 : '{i18n>expectedArrivalDate}'; //System current date
        expectedDeliveryDate     : Date                                             @title                 : '{i18n>expectedDeliveryDate}'; //System current date and user can change date-turn around time from contract s4 service will be stored in expected delivery date
        startDate                : Date                                             @title                 : '{i18n>startDate}'; //System current date
        endDate                  : Date                                             @title                 : '{i18n>endDate}'; //System current date
        mName                    : String                                           @title                 : '{i18n>mName}'; //Manufacturer Name
        mModel                   : String                                           @title                 : '{i18n>mModel}'; //Manufacturer Model
        mSerialNumber            : String                                           @title                 : '{i18n>mSerialNumber}'; //Manufacturer Serial Number
        mPartNumber              : String                                           @title                 : '{i18n>mPartNumber}'; //Manufacturer Part Number
        functionalLocation       : String                                           @title                 : '{i18n>functionalLocation}'; //VH for fucntional location s4 service with filter criteria(mname,mmodel and mserialNumber)
        functionalLocationName   : String                                           @title                 : '{i18n>functionalLocationName}'; //readonly field for functional location
        MaintenanceRevision      : String                                           @Common.SemanticObject : 'MaintenanceRevisionOverview'  @title     : '{i18n>MaintenanceRevision}'; // create by trigerring when request status is confirmed
        revisionType             : String                                           @title                 : '{i18n>revisionType}'; // It will hold the value as A1
        revisionText             : String                                           @title                 : '{i18n>revisionText}'; // concatenation of request Number and request Ddescription
        ccpersonName             : String                                           @title                 : '{i18n>ccpersonName}'  @UI.Placeholder    : 'Name'; //free text field comes from BP
        ccemail                  : String                                           @title                 : '{i18n>ccemail}'  @UI.Placeholder         : 'E-Mail'; //free text field comes from BP
        ccphoneNumber            : String                                           @title                 : '{i18n>ccphoneNumber}'  @UI.Placeholder   : 'Telephone Number'; //free text field comes from BP
        criticalityLevel         : Integer; //It will decide the color combination of Request status and Request phase
        emailFlag                : Boolean; //True indicates -> mail sent & false indicates -> mail not sent
        uiHidden                 : Boolean not null default false; //datafield to apply hidden criteria for request type and request status
        uiHidden1                : Boolean not null default true; //datafield to apply hidden criteria for request type and request status
        requestType1             : Integer                                          @title                 : '{i18n>requestType1}'; //to assign the request type at the time of edit and readonly field
        // requestStatus1           : String default 'Draft'                           @title                 : '{i18n>requestStatus1}'; //to assign the request status at the time of create and make it readonly field
        mrCount                  : Integer default 1; //Used in views to show count of the requests
        createdAtDate            : Date                                             @cds.on.insert         : $now  @title                              : '{i18n>createdAtDate}'; //Used as a filter criteria for Overview page(Date DataType works as a date picker)
        age                      : Integer default 0                                @title                 : '{i18n>age}'; //For representing Aging field
        to_requestType           : Association to RequestTypes                      @title :                 '{i18n>requestType}'  @assert.integrity   : false; //as dropdown - request number will generate through request type
        to_requestStatus         : Association to RequestStatuses                   @title :                 '{i18n>requestStatus}'  @assert.integrity : false; //at create = draft
        to_requestStatus1        : Association to RequestStatuses1                  @title :                 '{i18n>requestStatus}'  @assert.integrity : false; //at create = draft
        to_requestPhase          : Association to RequestPhases                     @title :                 '{i18n>requestPhase}'  @assert.integrity  : false; //at create = initial
        to_document              : Composition of many Documents
                                       on to_document.to_maintenanceRequest = $self @title                 : '{i18n>document}'; //One to many (1 MR - multiple documents links) i.e. Attaching multiple url w.r.t. MR
        to_botStatus             : Association to BotStatuses                       @title :                 '{i18n>botStatus}'  @assert.integrity     : false; // Status will get update when mail is sent to customer
        to_ranges                : Association to Ranges                            @title :                 '{i18n>ranges}'  @assert.integrity        : false; //Age Range (0-30,30-60,...)
};

entity RequestTypes {
    key ID    : Integer;
    key rType : String;
};

//It is used in change status action button as a drop down
entity RequestStatuses {
        // key ID          : Integer;
    key rStatus     : String default 'DRAFT';
    key rStatusDesc : String default 'Draft';
        to_rPhase   : Association to RequestPhases;
};

//It is used as Status drop down on list report page
entity RequestStatuses1 {
    key rStatus     : String default 'DRAFT';
    key rStatusDesc : String default 'Draft';
};

entity RequestPhases {
    key rPhase     : String default 'INITIATION';
    key rPhaseDesc : String default 'Initiation';
};

entity Documents : managed {
    key UUID                     : UUID                           @Core.Computed; //Unique ID as UUID
        ID                       : Integer                        @title :            '{i18n>document_ID}'; //It got incremented by 1 w.r.t. MR
        url                      : String                         @title :            '{i18n>document_url}'; //document url
        documentName             : String                         @title :            '{i18n>documentName}'; //url decription
        eMailRecievedDateAndTime : DateTime                       @title :            '{i18n>eMailRecievedDateAndTime}'; //E-Mail Recieved Date
        fileFormatCheckRequired  : Boolean not null default false @title :            '{i18n>fileFormatCheckRequired}'; // File Format Check RequiredY/N.
        formatCheck              : Boolean not null default false @title :            '{i18n>formatCheck}'; // Format Check Y/N.
        eMailSent                : Boolean not null default false @title :            '{i18n>eMailSent}'; // Email Sent Y/N
        workItemsCreated         : Boolean not null default false @title :            '{i18n>workItemsCreated}'; // WorkItems Created Y/N
        remarks                  : String                         @title :            '{i18n>remarks}'; // Remarks
        to_typeOfProcess         : Association to ProcessTypes    @assert.integrity : false  @title : '{i18n>to_typeOfProcess}'; //Processed By. Bot/ Manual
        to_typeOfAttachment      : Association to AttachmentTypes @assert.integrity : false  @title : '{i18n>to_typeOfAttachment}'; //Attachment Type (file extension)
        to_maintenanceRequest    : Association to MaintenanceRequests; //one to one(1 document link - 1 MR)
};

entity ProcessTypes {
    key ID          : Integer;
    key processType : String;
}

entity AttachmentTypes {
    key ID             : Integer;
    key attachmentType : String;
}

entity BotStatuses {
    key ID      : Integer; //Unique ID for Bot statuses
    key bStatus : String; //Bot status (Mail Sent, Mail Received, Request Validated, Work Items Created, Notifications Created)
};

entity Ranges {
    key ID    : Integer;
    key range : String;
};

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
}

entity RequestIndustries {
    key rIndustry : String //Industry
}

entity SchemaTypes {
    key sSchema : String //Search Schema
}

//Number of Request based on Request Statuses on Overview Page
@Aggregation.ApplySupported.PropertyRestrictions : true
view AggregatedMaintenanceReqOnStatuses as
    select from MaintenanceRequests {
        @Analytics.Dimension : true
        to_requestStatus1,
        createdAtDate,
        MaintenancePlanningPlant,
        locationWC,
        businessPartner1,
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
        to_requestPhase,
        createdAtDate,
        MaintenancePlanningPlant,
        locationWC,
        businessPartner1,
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
        to_requestStatus1,
        @Analytics.Dimension : true
        locationWC,
        businessPartner1,
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
        to_requestStatus1,
        @Analytics.Dimension : true
        locationWC,
        businessPartner1,
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
        to_requestStatus1,
        @Analytics.Dimension : true
        locationWC,
        businessPartner1,
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
        to_requestStatus1,
        businessPartner1,
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
        to_requestStatus1,
        businessPartner1,
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
        to_requestStatus1,
        businessPartner1,
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
view AggregatedReqByCompleteAssetAndRange as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true //
        to_requestStatus1,
        //businessPartner1,
        @Analytics.Dimension : true
        //bpConcatenation,
        to_ranges,
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
           to_requestStatus1.rStatusDesc = 'Draft'
        or to_requestStatus1.rStatusDesc = 'Created'
        or to_requestStatus1.rStatusDesc = 'Request for Work List'
        or to_requestStatus1.rStatusDesc = 'Requested Work List'
    );

//Number of Request based on MR type(Assembly) which has Ranges on x-axis and status on y-axis Created, Request for Work List, Requested Work List
@Aggregation.ApplySupported.PropertyRestrictions : true
view AggregatedReqByAssemblyAndRange as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true //
        to_requestStatus1,
        //businessPartner1,
        @Analytics.Dimension : true
        //bpConcatenation,
        to_ranges,
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
           to_requestStatus1.rStatusDesc = 'Draft'
        or to_requestStatus1.rStatusDesc = 'Created'
        or to_requestStatus1.rStatusDesc = 'Request for Work List'
        or to_requestStatus1.rStatusDesc = 'Requested Work List'
    );


//Number of Request based on MR type(Component) which has Ranges on x-axis and status on y-axis Created, Request for Work List, Requested Work List
@Aggregation.ApplySupported.PropertyRestrictions : true
view AggregatedReqByComponentAndRange as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true //
        to_requestStatus1,
        //businessPartner1,
        @Analytics.Dimension : true
        //bpConcatenation,
        to_ranges,
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
           to_requestStatus1.rStatusDesc = 'Draft'
        or to_requestStatus1.rStatusDesc = 'Created'
        or to_requestStatus1.rStatusDesc = 'Request for Work List'
        or to_requestStatus1.rStatusDesc = 'Requested Work List'
    );

//Number of Request based on MR type(Complete Asset) which has Ranges on x-axis and status on y-axis 
@Aggregation.ApplySupported.PropertyRestrictions : true
view AggregatedReqByCompleteAssetAndRange1 as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true //
        to_requestStatus1,
        //businessPartner1,
        @Analytics.Dimension : true
        //bpConcatenation,
        to_ranges,
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
           to_requestStatus1.rStatusDesc = 'Draft'
        or to_requestStatus1.rStatusDesc = 'Requested Work List'
        or to_requestStatus1.rStatusDesc = 'Ready for Approval'
        or to_requestStatus1.rStatusDesc = 'Updated Task List'
        or to_requestStatus1.rStatusDesc = 'Created Revision'
        or to_requestStatus1.rStatusDesc = 'Created Notification'
    );

//Number of Request based on MR type(Assembly) which has Ranges on x-axis and status on y-axis 
@Aggregation.ApplySupported.PropertyRestrictions : true
view AggregatedReqByAssemblyAndRange1 as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true //
        to_requestStatus1,
        //businessPartner1,
        @Analytics.Dimension : true
        //bpConcatenation,
        to_ranges,
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
           to_requestStatus1.rStatusDesc = 'Draft'
        or to_requestStatus1.rStatusDesc = 'Requested Work List'
        or to_requestStatus1.rStatusDesc = 'Ready for Approval'
        or to_requestStatus1.rStatusDesc = 'Updated Task List'
        or to_requestStatus1.rStatusDesc = 'Created Revision'
        or to_requestStatus1.rStatusDesc = 'Created Notification'
    );

//Number of Request based on MR type(Component) which has Ranges on x-axis and status on y-axis 
@Aggregation.ApplySupported.PropertyRestrictions : true
view AggregatedReqByComponentAndRange1 as
    select from MaintenanceRequests {
        to_requestType,
        @Analytics.Dimension : true //
        to_requestStatus1,
        //businessPartner1,
        @Analytics.Dimension : true
        //bpConcatenation,
        to_ranges,
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
           to_requestStatus1.rStatusDesc = 'Draft'
        or to_requestStatus1.rStatusDesc = 'Requested Work List'
        or to_requestStatus1.rStatusDesc = 'Ready for Approval'
        or to_requestStatus1.rStatusDesc = 'Updated Task List'
        or to_requestStatus1.rStatusDesc = 'Created Revision'
        or to_requestStatus1.rStatusDesc = 'Created Notification'
    );
