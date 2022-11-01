using mrorequestdolphinService as service from '../../srv/mro-requestdolphin-service';

annotate service.BillOfWorks with @(UI : {
    //Selection Fields in Header of List Report Page
    SelectionFields          : [Bowid],
    //Line Item in List Report Page
    LineItem                 : [
        {
            Value                 : Bowid,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : requestNo,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : to_maintenanceRequest.MaintenanceRevision,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : salesOrganization,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : currency,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : devision,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : distributionChannel,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : to_maintenanceRequest.MaintenancePlanningPlant,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : serviceProduct,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : standardProject,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : to_maintenanceRequest.locationWC,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        }
    ],
    PresentationVariant      : {
        SortOrder      : [{
            $Type      : 'Common.SortOrderType',
            Property   : createdAt,
            Descending : true,
        }, ],
        Visualizations : ['@UI.LineItem']
    },
    //Header Information in Object Page
    HeaderInfo               : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : 'Bill of Work Details', //Label of object page
        TypeNamePlural : 'Bill of Work', //Label on list
        Title          : {Value : Bowid},
    //Description    : {Value : }
    },
    HeaderFacets             : [
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'basicDetail1',
            Target : '@UI.FieldGroup#basicDetail1',
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'basicDetail2',
            Target : '@UI.FieldGroup#basicDetail2',
        }
    ],
    //Facets Information in Object Page
    Facets                   : [{
        $Type  : 'UI.CollectionFacet',
        ID     : 'mrInfo',
        Label  : 'Maintenance Request Information',
        Facets : [
            {
                $Type  : 'UI.ReferenceFacet',
                ID     : 'mrInfo1',
                Target : '@UI.FieldGroup#mrInfo1',
            //Label  : 'Work Item Information'
            },
            {
                $Type  : 'UI.ReferenceFacet',
                ID     : 'mrInfo2',
                Target : '@UI.FieldGroup#mrInfo2',
            //Label  : 'Technical Reference'
            },
            {
                $Type  : 'UI.ReferenceFacet',
                ID     : 'mrInfo3',
                Target : '@UI.FieldGroup#mrInfo3',
            //Label  : 'Additional Information'
            },
        ],
    }, ],
    FieldGroup #basicDetail1 : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : createdBy},
            {Value : modifiedBy}
        ]
    },
    FieldGroup #basicDetail2 : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : createdAt},
            {Value : modifiedAt}
        ]
    },

    //Tab 2 = Customer Information Field Group
    FieldGroup #mrInfo1      : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : requestNo},
            {Value : to_maintenanceRequest.to_requestType_rType},
            {Value : to_maintenanceRequest.businessPartner},
            {Value : to_maintenanceRequest.SalesContract},
            {Value : to_maintenanceRequest.MaintenanceRevision}
        ],
    },
    FieldGroup #mrInfo2      : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : to_maintenanceRequest.locationWC},
            {Value : to_maintenanceRequest.MaintenancePlanningPlant},
            {Value : currency},
            {Value : to_maintenanceRequest.expectedArrivalDate},
            {Value : to_maintenanceRequest.expectedDeliveryDate}
        ]
    },
    FieldGroup #mrInfo3      : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : to_maintenanceRequest.functionalLocation},
            {Value : to_maintenanceRequest.equipment},
            //{Value : to_maintenanceRequest.to_workItems.workOrderNo}
        ]
    }
});

/*annotate service.BillOfWorks with {
    requestNo @(Common : {ValueList : {
        CollectionPath : 'MaintenanceRequests',
        Label          : 'Maintenance Request',
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'requestNo',
                ValueListProperty : 'requestNo'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'to_maintenanceRequest/to_requestType_rType',
                ValueListProperty : 'to_requestType_rType'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'to_maintenanceRequest/businessPartner',
                ValueListProperty : 'businessPartner'
            },
        // {
        //     $Type             : 'Common.ValueListParameterFilterOnly',
        //     ValueListProperty : 'locationWC'
        // },
        // {
        //     $Type             : 'Common.ValueListParameterFilterOnly',
        //     ValueListProperty : 'locationWCDetail'
        // },
        // {
        //     $Type             : 'Common.ValueListParameterOut',
        //     LocalDataProperty : 'planningPlant',
        //     ValueListProperty : 'MaintenancePlanningPlant'
        // },
        // {
        //     $Type             : 'Common.ValueListParameterFilterOnly',
        //     ValueListProperty : 'SalesContract'
        // },
        // {
        //     $Type             : 'Common.ValueListParameterFilterOnly',
        //     ValueListProperty : 'contractName'
        // },

        // {
        //     $Type             : 'Common.ValueListParameterFilterOnly',
        //     ValueListProperty : 'functionalLocation'
        // },
        // {
        //     $Type             : 'Common.ValueListParameterFilterOnly',
        //     ValueListProperty : 'functionalLocationName'
        // },
        // {
        //     $Type             : 'Common.ValueListParameterFilterOnly',
        //     ValueListProperty : 'equipment'
        // },
        // {
        //     $Type             : 'Common.ValueListParameterFilterOnly',
        //     ValueListProperty : 'equipmentName'
        // },
        // {
        //     $Type             : 'Common.ValueListParameterFilterOnly',
        //     ValueListProperty : 'MaintenanceRevision'
        // }
        ]
    }});
};*/
