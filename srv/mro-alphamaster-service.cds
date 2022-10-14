using {MAINTREQ_SB as s4maintReq} from './external/MAINTREQ_SB';

service alphamasterService {

    @readonly
    entity BusinessPartnerVH   as projection on s4maintReq.BusinessPartnerVH {
        key BusinessPartner,
        key BusinessPartnerRole,
        key SalesContract,
            BusinessPartnerRoleName,
            BusinessPartnerName,
            FirstName,
            LastName,
            ContactPersonEmailID,
            ContactPersonName,
            TelephoneNo,
            SearchTerm1,
            SearchTerm2,
            TurnAroundTime
    };

    @readonly
    entity WorkCenterVH        as projection on s4maintReq.WorkCenterVH {
        key Plant,
        key WorkCenter,
            WorkCenterCategoryCode,
            WorkCenterText,
            PlantName
    };

    @readonly
    entity SalesContractVH     as projection on s4maintReq.SalesContractVH {
        key SalesContract,
            SalesContractName,
            SoldToPartyBP,
            TurnAroundTime
    };

    @readonly
    entity FunctionLocationVH  as projection on s4maintReq.FunctionLocationVH {
        key functionalLocation,
            FunctionalLocationName,
            ManufacturerPartTypeName,
            ManufacturerSerialNumber,
            ManufacturerName,
            ManufacturerPartNmbr,
            Plant
    };

    @readonly
    entity EquipmentVH         as projection on s4maintReq.EquipmentVH {
        key Equipment,
            EquipmentName,
            Material,
            MaterialName,
            SerialNumber,
            Plant,
            FunctionalLocation
    };

    entity Revisions           as projection on s4maintReq.MaintRevision {
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

    entity MaintNotifications  as projection on s4maintReq.MaintNotification {
        MaintenanceNotification,
        NotificationText,
        NotificationType
    };

    entity ReferenceTaskListVH as projection on s4maintReq.ReferenceTaskListVH {
        key TaskListType,
        key TaskListGroup,
        key TaskListGroupCounter,
        key ExternalReference,
        key DocumentInfoRecordDocNumber,
        key DocumentInfoRecordDocVersion,
            TaskListDesc,
            ExternalCustomerReference,
            Plant
    };
}
