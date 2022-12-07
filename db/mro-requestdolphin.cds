namespace com.hcl.mro.requestdolphin;

using {
    managed,
    sap.common,
} from '@sap/cds/common';

entity MaintenanceRequests : managed {
    key ID              : UUID   @title : 'ID'         @Core.Computed; //unique ID for Maintenace request
        requestDesc     : String @title : 'Request Desc'; 
        businessPartner : String @title : 'Business Partner'; 
        to_requestType  : Association to RequestTypes  @title : 'Request Type'  @assert.integrity : false; //as dropdown - request number will generate through request type                                                                                                             @title : '{i18n>range}'  @assert.integrity       : false; //Age Range (0-30,30-60,...)
        to_workItems    : Association to many WorkItems;
};

entity RequestTypes {
    key rType : String;
};

entity WorkItems : managed {
    key ID                    : UUID  @title : 'ID'  @Core.Computed;
        to_maintenanceRequest : Association to one MaintenanceRequests; //One to one association to MR
};
