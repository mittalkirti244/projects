using {MAINTREQ_SB as s4maintReq} from './external/MAINTREQ_SB';

service alphamasterService {

    @readonly
    entity BusinessPartnerVH   as projection on s4maintReq.BusinessPartnerVH {
        key BusinessPartner,
            BusinessPartnerName,
            FirstName,
            LastName,
            Description,
            ContactPersonEmailID,
            ContactPersonName,
            TelephoneNo,
            SearchTerm1,
            SearchTerm2
    };

    @readonly
    entity WorkCenterVH        as projection on s4maintReq.WorkCenterVH {
        key Plant,
        key WorkCenter,
            WorkCenterCategoryCode,
            WorkCenterText
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
}
