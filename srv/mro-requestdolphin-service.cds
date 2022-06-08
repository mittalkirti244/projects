using {com.hcl.mro.requestdolphin as maintReq} from '../db/mro-requestdolphin';
using {NumberRangeService as numberRange} from './external/NumberRangeService';
using {alphamasterService as alpha} from './mro-alphamaster-service';

service mrorequestdolphinService {

    entity NumberRanges        as projection on numberRange.NumberRanges;

    @odata.draft.enabled
    @cds.redirection.target
    entity MaintenanceRequests as projection on maintReq.MaintenanceRequests actions {
        action requestMail();
    };

    entity RevisionVH          as
        select from maintReq.MaintenanceRequests {
            MaintenanceRevision,
            revisionText @UI.HiddenFilter,
            revisionType
        }
        where
            to_requestStatus.rStatus = 'Revision Created';

    entity RequestTypes        as projection on maintReq.RequestTypes;
    entity RequestStatuses     as projection on maintReq.RequestStatuses;
    entity RequestPhases       as projection on maintReq.RequestPhases;

    @Capabilities.SearchRestrictions : {
        $Type      : 'Capabilities.SearchRestrictionsType',
        Searchable : false
    }
    @Capabilities.SortRestrictions   : {
        ![@UI.Hidden],
        $Type    : 'Capabilities.SortRestrictionsType',
        Sortable : false
    }
    entity Documents           as projection on maintReq.Documents;

    entity BotStatuses         as projection on maintReq.BotStatuses;
    entity ProcessTypes        as projection on maintReq.ProcessTypes;
    entity AttachmentTypes     as projection on maintReq.AttachmentTypes;
    entity Configurations      as projection on maintReq.Configurations;
    entity RequestIndustries   as projection on maintReq.RequestIndustries;
    entity SchemaTypes         as projection on maintReq.SchemaTypes;
    view AggregatedMaintenanceReqOnStatuses as select from maintReq.AggregatedMaintenanceReqOnStatuses;
    view AggregatedMaintenanceReqOnPhases as select from maintReq.AggregatedMaintenanceReqOnPhases;
    view AggregatedReqByCompleteAssetAndWC as select from maintReq.AggregatedReqByCompleteAssetAndWC;
    view AggregatedReqByComponentAndWC as select from maintReq.AggregatedReqByComponentAndWC;
    view AggregatedReqByAssemblyAndWC as select from maintReq.AggregatedReqByAssemblyAndWC;
    view AggregatedReqByCompleteAssetAndBP as select from maintReq.AggregatedReqByCompleteAssetAndBP;
    view AggregatedReqByComponentAndBP as select from maintReq.AggregatedReqByComponentAndBP;
    view AggregatedReqByAssemblyAndBP as select from maintReq.AggregatedReqByAssemblyAndBP;

};

extend service mrorequestdolphinService with {

    @readonly
    entity BusinessPartnerVH  as projection on alpha.BusinessPartnerVH {
        key BusinessPartner      @(Common.Label : '{i18n>BusinessPartner}'),
            BusinessPartnerName  @(Common.Label : '{i18n>BusinessPartnerName}') @UI.HiddenFilter,
            FirstName            @(Common.Label : '{i18n>FirstName}'),
            LastName             @(Common.Label : '{i18n>LastName}'),
            SearchTerm1          @(Common.Label : '{i18n>SearchTerm1}'),
            SearchTerm2          @(Common.Label : '{i18n>SearchTerm2}'),
            Description          @(Common.Label : '{i18n>Description}') @UI.HiddenFilter,
            ContactPersonName    @(Common.Label : '{i18n>ContactPersonName}') @UI.HiddenFilter,
            ContactPersonEmailID @(Common.Label : '{i18n>ContactPersonEmailID}'),
            TelephoneNo          @(Common.Label : '{i18n>TelephoneNo}')
    };

    @readonly
    entity WorkCenterVH       as projection on alpha.WorkCenterVH {
        key WorkCenter             @(Common.Label : '{i18n>WorkCenter}'),
        key Plant                  @(Common.Label : '{i18n>Plant}'),
            WorkCenterText         @(Common.Label : '{i18n>WorkCenterText}'),
            WorkCenterCategoryCode @(Common.Label : '{i18n>WorkCenterCategoryCode}')
    };

    @readonly
    entity FunctionLocationVH as projection on alpha.FunctionLocationVH {
        key functionalLocation       @(Common.Label : '{i18n>functionalLocation}'),
            FunctionalLocationName   @(Common.Label : '{i18n>FunctionalLocationName}'),
            ManufacturerName         @(Common.Label : '{i18n>ManufacturerName}'),
            ManufacturerPartTypeName @(Common.Label : '{i18n>ManufacturerPartTypeName}'),
            ManufacturerPartNmbr     @(Common.Label : '{i18n>ManufacturerPartNmbr}'),
            ManufacturerSerialNumber @(Common.Label : '{i18n>ManufacturerSerialNumber}'),
            Plant                    @UI.HiddenFilter
    };

    @readonly
    entity SalesContractVH    as projection on alpha.SalesContractVH {
        key SalesContract     @(Common.Label : '{i18n>SalesContract}'),
            SalesContractName @(Common.Label : '{i18n>SalesContractName}'),
            TurnAroundTime    @(Common.Label : '{i18n>TurnAroundTime}'),
            SoldToPartyBP     @(Common.Label : '{i18n>SoldToPartyBP}') @UI.HiddenFilter

    };

    @readonly
    entity EquipmentVH        as projection on alpha.EquipmentVH {
        key Equipment,
            EquipmentName      @(Common.Label : '{i18n>EquipmentName}'),
            FunctionalLocation @(Common.Label : '{i18n>functionalLocation}'),
            Material,
            MaterialName       @UI.HiddenFilter,
            SerialNumber       @(Common.Label : '{i18n>SerialNumber}'),
            Plant              @UI.HiddenFilter
    };

    entity Revisions          as projection on alpha.Revisions {
        key PlanningPlant,
        key RevisionNo,
            Equipment,
            FunctionLocation,
            RevisionEndDate,
            RevisionEndTime,
            RevisionStartDate,
            RevisionStartTime,
            RevisionText,
            RevisionType,
            WorkCenter,
            WorkCenterPlant
    };
}

//Request Type as Drop down
annotate mrorequestdolphinService.Configurations with {
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

//Industry as drop down
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

//Schema Type as a drop down
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

// //label for Request Type, Search Schema, Industry
annotate mrorequestdolphinService.Configurations with {
    manufacturerName   @(Common.Label : '{i18n>manufacturerName}');
    manfuracterModel   @(Common.Label : '{i18n>manfuracterModel}');
    manurafacturerSl   @(Common.Label : '{i18n>manurafacturerSl}');
    materialNo         @(Common.Label : '{i18n>material}');
    serialNo           @(Common.Label : '{i18n>mSerial}');
    to_requestType     @(Common.Label : '{i18n>requestType_rType}');
    to_requestIndustry @(Common.Label : '{i18n>requestIndustry_rIndustry}');
    to_schemaType      @(Common.Label : '{i18n>schemaType_sSchema}')

}

//Filter restriction that is used for Semantic date filter on overview page
annotate mrorequestdolphinService.MaintenanceRequests with @Common.FilterExpressionRestrictions : [{
    Property           : createdAtDate,
    AllowedExpressions : #SingleInterval
}];
