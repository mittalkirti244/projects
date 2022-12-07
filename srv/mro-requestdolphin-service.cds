using {com.hcl.mro.requestdolphin as maintReq} from '../db/mro-requestdolphin';

service mrorequestdolphinService {

    @odata.draft.enabled
    entity MaintenanceRequests as projection on maintReq.MaintenanceRequests {
        *,
        createdAt  @(Common.Label : '{i18n>createdAt}'),
        createdBy  @(Common.Label : '{i18n>createdBy}'),
        modifiedAt @(Common.Label : '{i18n>modifiedAt}'),
        modifiedBy @(Common.Label : '{i18n>modifiedBy}')
    };

    entity RequestTypes        as projection on maintReq.RequestTypes;

    @odata.draft.enabled
    @cds.redirection.target : false
    entity WorkItems           as projection on maintReq.WorkItems {
        *,
        createdAt  @(Common.Label : '{i18n>createdAt}'),
        createdBy  @(Common.Label : '{i18n>createdBy}'),
        modifiedAt @(Common.Label : '{i18n>modifiedAt}'),
        modifiedBy @(Common.Label : '{i18n>modifiedBy}')
    };
}
