using {com.hcl.mro.requestdolphin as maintReq} from '../db/mro-requestdolphin';
using {NumberRangeService as numberRange} from './external/NumberRangeService';
using {alphamasterService as alpha} from './mro-alphamaster-service';
using {notifleo} from './external/notifleo';

service mrorequestdolphinService {

    @odata.draft.enabled
    @cds.redirection.target
    entity MaintenanceRequests     as projection on maintReq.MaintenanceRequests actions {
        //action requestMail();
        //Update the UI after action is performed
        @(
            cds.odata.bindingparameter.name : '_it',
            Common.SideEffects              : {TargetProperties : [
                '_it/to_requestStatus_rStatusDesc',
                '_it/to_requestStatusDisp_rStatusDesc',
                '_it/to_requestPhase_rPhaseDesc',
                '_it/to_requestStatusDisp_rStatus',
                '_it/to_requestStatus_rStatus',
                '_it/to_requestPhase_rPhase',
                '_it/changeStatusFlag',
                '_it/updateRevisionFlag'
            ]}
        )
        //@core.operation available is used for disable and enable of action button
        //change Status will be disable at the time of create - set as false in db
        @Core :                                       {OperationAvailable : _it.changeStatusFlag}
        action changeStatus(status : String @Common : {
            Label     : '{i18n>status}',
            ValueListWithFixedValues,
            /*Text      : {
                $value                 : to_requestType_rType,
                ![@UI.TextArrangement] : #TextFirst
            },*/
            ValueList : {
                $Type          : 'Common.ValueListType',
                CollectionPath : 'RequestStatuses',
                Parameters     : [
                    {
                        $Type             : 'Common.ValueListParameterInOut',
                        LocalDataProperty : 'status',
                        ValueListProperty : 'rStatusDesc'
                    },
                    {
                        $Type             : 'Common.ValueListParameterDisplayOnly',
                        ValueListProperty : 'to_rPhase_rPhaseDesc'
                    }
                ]
            }
        });

        //Update the UI after action revisionCreated
        @(
            cds.odata.bindingparameter.name : '_it',
            Common.SideEffects              : {TargetProperties : [
                '_it/to_requestStatus_rStatusDesc',
                '_it/to_requestStatusDisp_rStatusDesc',
                '_it/to_requestPhase_rPhaseDesc',
                '_it/revision',
                '_it/MaintenanceRevision',
                '_it/to_requestStatusDisp_rStatus',
                '_it/to_requestStatus_rStatus',
                '_it/to_requestPhase_rPhase',
                '_it/updateRevisionFlag'
            ]}
        )
        //@core.operation available is used for disable and enable of action button
        //Update Revision will be disable at the time of create - set as false in db
        @Core :                                       {OperationAvailable : _it.updateRevisionFlag}
        action revisionCreated();
    };

    entity RequestTypes            as projection on maintReq.RequestTypes;
    entity RequestStatuses         as projection on maintReq.RequestStatuses;
    entity RequestStatusesDisp     as projection on maintReq.RequestStatusesDisp;
    entity RequestPhases           as projection on maintReq.RequestPhases;

    //Request Number value Help for List Page
    entity MaintenanceRequestsDisp as projection on maintReq.MaintenanceRequests {
        requestNoConcat @UI.HiddenFilter,
        requestDesc     @UI.HiddenFilter
    };

    //Revision Number Entity used for value help in List report page
    entity RevisionDisp            as
        select from maintReq.MaintenanceRequests {
            MaintenanceRevision,
            revisionText @UI.HiddenFilter,
            revisionType
        }
        where
               to_requestStatusDisp.rStatus =  'RVCRTD'
            or to_requestStatusDisp.rStatus =  'NTCRTD'
            or to_requestStatusDisp.rStatus =  'MRCMPL'
            or revision                     != '';

    @Capabilities.SearchRestrictions : {
        $Type      : 'Capabilities.SearchRestrictionsType',
        Searchable : false
    }
    @Capabilities.SortRestrictions   : {
        ![@UI.Hidden],
        $Type    : 'Capabilities.SortRestrictionsType',
        Sortable : false
    }
    entity Documents               as projection on maintReq.Documents;

    entity AttachmentTypes         as projection on maintReq.AttachmentTypes;
    entity DocumentStatuses        as projection on maintReq.DocumentStatuses;
    entity BotStatuses             as projection on maintReq.BotStatuses;
    //entity ProcessTypes         as projection on maintReq.ProcessTypes;

    entity Ranges                  as projection on maintReq.Ranges;
    //All views used for Overview page
    view AggregatedMaintenanceReqOnStatuses as select from maintReq.AggregatedMaintenanceReqOnStatuses;
    view AggregatedMaintenanceReqOnPhases as select from maintReq.AggregatedMaintenanceReqOnPhases;
    view AggregatedReqByCompleteAssetAndWC as select from maintReq.AggregatedReqByCompleteAssetAndWC;
    view AggregatedReqByComponentAndWC as select from maintReq.AggregatedReqByComponentAndWC;
    view AggregatedReqByAssemblyAndWC as select from maintReq.AggregatedReqByAssemblyAndWC;
    view AggregatedReqByCompleteAssetAndBP as select from maintReq.AggregatedReqByCompleteAssetAndBP;
    view AggregatedReqByComponentAndBP as select from maintReq.AggregatedReqByComponentAndBP;
    view AggregatedReqByAssemblyAndBP as select from maintReq.AggregatedReqByAssemblyAndBP;
    view ReqByCompleteAssetAndRangeUntilRequestedWorkList as select from maintReq.ReqByCompleteAssetAndRangeUntilRequestedWorkList;
    view ReqByAssemblyAndRangeUntilRequestedWorkList as select from maintReq.ReqByAssemblyAndRangeUntilRequestedWorkList;
    view ReqByComponentAndRangeUntilRequestedWorkList as select from maintReq.ReqByComponentAndRangeUntilRequestedWorkList;
    view ReqByCompleteAssetAndRangeOverallStatus as select from maintReq.ReqByCompleteAssetAndRangeOverallStatus;
    view ReqByAssemblyAndRangeOverallStatus as select from maintReq.ReqByAssemblyAndRangeOverallStatus;
    view ReqByComponentAndRangeOverallStatus as select from maintReq.ReqByComponentAndRangeOverallStatus;
    view ReqByCompleteAssetAndRangeUntilNotifications as select from maintReq.ReqByCompleteAssetAndRangeUntilNotifications;
    view ReqByAssemblyAndRangeUntilNotifications as select from maintReq.ReqByAssemblyAndRangeUntilNotifications;
    view ReqByComponentAndRangeUntilNotifications as select from maintReq.ReqByComponentAndRangeUntilNotifications;
    view ReqByCompleteAssetAndRangePendingRevision as select from maintReq.ReqByCompleteAssetAndRangePendingRevision;
    view ReqByAssemblyAndRangePendingRevision as select from maintReq.ReqByAssemblyAndRangePendingRevision;
    view ReqByComponentAndRangePendingRevision as select from maintReq.ReqByComponentAndRangePendingRevision;
    //To Calculate and Update aging
    function calculateAgingFunc()                               returns String;
    //To Change Document Status in Documents Tab
    function changeDocumentStatus(status : String, ID : String) returns String;
    //Entities for Admin SCreen
    entity Configurations          as projection on maintReq.Configurations;
    entity RequestIndustries       as projection on maintReq.RequestIndustries;
    entity SchemaTypes             as projection on maintReq.SchemaTypes;
};

//Maintained all entites that is coming from external
extend service mrorequestdolphinService with {

    entity NumberRanges             as projection on numberRange.NumberRanges;
    entity MaintenanceRequestHeader as projection on notifleo.MaintenanceRequestHeader;

    @readonly
    entity BusinessPartnerVH        as projection on alpha.BusinessPartnerVH {
        key BusinessPartner      @(Common.Label : '{i18n>BusinessPartner}'),
            BusinessPartnerName  @(Common.Label : '{i18n>BusinessPartnerName}') @UI.HiddenFilter,
            FirstName            @(Common.Label : '{i18n>FirstName}') @UI.HiddenFilter,
            LastName             @(Common.Label : '{i18n>LastName}') @UI.HiddenFilter,
            SearchTerm1          @(Common.Label : '{i18n>SearchTerm1}') @UI.HiddenFilter,
            SearchTerm2          @(Common.Label : '{i18n>SearchTerm2}') @UI.HiddenFilter,
            Description          @(Common.Label : '{i18n>Description}') @UI.HiddenFilter,
            ContactPersonName    @(Common.Label : '{i18n>ContactPersonName}') @UI.HiddenFilter,
            ContactPersonEmailID @(Common.Label : '{i18n>ContactPersonEmailID}'),
            TelephoneNo          @(Common.Label : '{i18n>TelephoneNo}')
    };

    @readonly
    entity WorkCenterVH             as projection on alpha.WorkCenterVH {
        key Plant                  @(Common.Label : '{i18n>Plant}'),
        key WorkCenter             @(Common.Label : '{i18n>WorkCenter}'),
            WorkCenterText         @(Common.Label : '{i18n>WorkCenterText}'),
            WorkCenterCategoryCode @(Common.Label : '{i18n>WorkCenterCategoryCode}'),
            PlantName              @(Common.Label : '{i18n>PlantName}')
    };

    @readonly
    entity FunctionLocationVH       as projection on alpha.FunctionLocationVH {
        key functionalLocation       @(Common.Label : '{i18n>functionalLocation}'),
            FunctionalLocationName   @(Common.Label : '{i18n>FunctionalLocationName}'),
            ManufacturerName         @(Common.Label : '{i18n>ManufacturerName}'),
            ManufacturerPartTypeName @(Common.Label : '{i18n>ManufacturerPartTypeName}'),
            ManufacturerPartNmbr     @(Common.Label : '{i18n>ManufacturerPartNmbr}'),
            ManufacturerSerialNumber @(Common.Label : '{i18n>ManufacturerSerialNumber}'),
            Plant                    @UI.HiddenFilter
    };

    @readonly
    entity SalesContractVH          as projection on alpha.SalesContractVH {
        key SalesContract     @(Common.Label : '{i18n>SalesContract}'),
            SalesContractName @(Common.Label : '{i18n>SalesContractName}'),
            TurnAroundTime    @(Common.Label : '{i18n>TurnAroundTime}'),
            SoldToPartyBP     @(Common.Label : '{i18n>SoldToPartyBP}') @UI.HiddenFilter
    };

    @readonly
    entity EquipmentVH              as projection on alpha.EquipmentVH {
        key Equipment,
            EquipmentName      @(Common.Label : '{i18n>EquipmentName}'),
            FunctionalLocation @(Common.Label : '{i18n>functionalLocation}'),
            Material,
            MaterialName       @UI.HiddenFilter,
            SerialNumber       @(Common.Label : '{i18n>SerialNumber}'),
            Plant              @UI.HiddenFilter
    };

    entity RevisionVH               as projection on alpha.Revisions {
        key PlanningPlant     @UI.HiddenFilter,
        key RevisionNo        @(Common.Label : '{i18n>RevisionNo}'),
            Equipment         @UI.HiddenFilter,
            FunctionLocation  @UI.HiddenFilter,
            RevisionEndDate   @UI.HiddenFilter,
            RevisionEndTime   @UI.HiddenFilter,
            RevisionStartDate @UI.HiddenFilter,
            RevisionStartTime @UI.HiddenFilter,
            RevisionText      @UI.HiddenFilter @(Common.Label : '{i18n>RevisionText}'),
            RevisionType      @(Common.Label : '{i18n>RevisionType}'),
            WorkCenter        @(Common.Label : '{i18n>WorkCenter}'),
            WorkCenterPlant   @(Common.Label : '{i18n>Plant}')
    };
}

//Filter restriction that is used for (Semantic date filter) on overview page
annotate mrorequestdolphinService.MaintenanceRequests with @Common.FilterExpressionRestrictions : [{
    Property           : createdAtDate,
    AllowedExpressions : #SingleInterval
}];

//Admin Screen
//Request Type as Drop down for Admin Screen
/*annotate mrorequestdolphinService.Configurations with {
    to_requestType @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'RequestTypes',
            Label          : '{i18n>requestType}',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'to_requestType_ID',
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'to_requestType_rType',
                    ValueListProperty : 'rType'
                }
            ]
        }
    })
};

//Industry as drop down for Admin Screen
annotate mrorequestdolphinService.Configurations with {
    to_requestIndustry @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'RequestIndustries',
            Label          : '{i18n>requestIndustry}',
            Parameters     : [{
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'to_requestIndustry_rIndustry',
                ValueListProperty : 'rIndustry'
            }]
        }
    });
};

//Schema Type as a drop down for Admin Screen
annotate mrorequestdolphinService.Configurations with {
    to_schemaType @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'SchemaTypes',
            Label          : '{i18n>schemaType}',
            Parameters     : [{
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'to_schemaType_sSchema',
                ValueListProperty : 'sSchema'
            }]
        }
    });
};

//Label defination for Request Type, Search Schema, Industry for Admin Screen
annotate mrorequestdolphinService.Configurations with {
    manufacturerName   @(Common.Label : '{i18n>manufacturerName}');
    manfuracterModel   @(Common.Label : '{i18n>manfuracterModel}');
    manurafacturerSl   @(Common.Label : '{i18n>manurafacturerSl}');
    materialNo         @(Common.Label : '{i18n>material}');
    serialNo           @(Common.Label : '{i18n>mSerial}');
    to_requestType     @(Common.Label : '{i18n>requestType_rType}');
    to_requestIndustry @(Common.Label : '{i18n>requestIndustry_rIndustry}');
    to_schemaType      @(Common.Label : '{i18n>schemaType_sSchema}')

}*/
