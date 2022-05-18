const cds = require('@sap/cds')

module.exports = cds.service.impl(async function () {
    const {
        BusinessPartnerVH,
        WorkCenterVH,
        FunctionLocationVH,
        SalesContractVH,
        EquipmentVH,
        Revisions,
        SalesContractItemVH,
        UnitOfMeasureVH } = this.entities
    const service = await cds.connect.to('MAINTREQ_SB');

    this.on('READ', [BusinessPartnerVH,
        WorkCenterVH,
        FunctionLocationVH,
        SalesContractVH,
        EquipmentVH,
        Revisions,
        SalesContractItemVH,
        UnitOfMeasureVH], req => {
            return service.tx(req).run(req.query);
        });
})

