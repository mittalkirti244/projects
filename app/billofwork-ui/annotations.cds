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
            Value                 : MaintenanceRevision,
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
            Value                 : MaintenancePlanningPlant,
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
            Value                 : workLocation,
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
    Facets                   : [
        {
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
        },
        {
            $Type  : 'UI.CollectionFacet',
            ID     : 'bowInfo',
            Label  : 'Bill of Work',
            Facets : [
                {
                    $Type  : 'UI.ReferenceFacet',
                    ID     : 'bowInfo1',
                    Target : '@UI.FieldGroup#bowInfo1',
                //Label  : 'Work Item Information'
                },
                {
                    $Type  : 'UI.ReferenceFacet',
                    ID     : 'bowInfo2',
                    Target : '@UI.FieldGroup#bowInfo2',
                //Label  : 'Technical Reference'
                },
                {
                    $Type  : 'UI.ReferenceFacet',
                    ID     : 'bowInfo3',
                    Target : '@UI.FieldGroup#bowInfo3',
                //Label  : 'Additional Information'
                },
            ],
        }
    ],
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
            {Value : requestType},
            {Value : businessPartner},
            {Value : SalesContract},
            {Value : MaintenanceRevision}
        ],
    },
    FieldGroup #mrInfo2      : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : workLocation},
            {Value : MaintenancePlanningPlant},
            {Value : currency},
            {Value : expectedArrivalDate},
            {Value : expectedDeliveryDate}
        ]
    },
    FieldGroup #mrInfo3      : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : functionalLocation},
            {Value : equipment},
            {Value : workOrderNo}
        ]
    },
    FieldGroup #bowInfo1     : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : bowType},
            {Value : salesOrganization},
            {Value : serviceProduct}
        ]
    },
    FieldGroup #bowInfo2     : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : bowDesc},
            {Value : distributionChannel},
            {Value : standardProject}
        ]
    },
    FieldGroup #bowInfo3     : {
        $Type : 'UI.FieldGroupType',
        Data  : [{Value : devision}]
    }
});

annotate service.BillOfWorks with {
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
                LocalDataProperty : 'requestType',
                ValueListProperty : 'to_requestType_rType'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'businessPartner',
                ValueListProperty : 'businessPartner'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'SalesContract',
                ValueListProperty : 'SalesContract'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'MaintenanceRevision',
                ValueListProperty : 'MaintenanceRevision'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'workLocation',
                ValueListProperty : 'locationWC'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'MaintenancePlanningPlant',
                ValueListProperty : 'MaintenancePlanningPlant'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'expectedArrivalDate',
                ValueListProperty : 'expectedArrivalDate'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'expectedDeliveryDate',
                ValueListProperty : 'expectedDeliveryDate'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'functionalLocation',
                ValueListProperty : 'functionalLocation'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'equipment',
                ValueListProperty : 'equipment'
            },
        // {
        //     $Type             : 'Common.ValueListParameterOut',
        //     LocalDataProperty : 'workOrderNo',
        //    // ValueListProperty : 'to_'
        // }
        ]
    }});
};

annotate service.BillOfWorks with {
    salesOrganization @(Common : {ValueList : {
        CollectionPath : 'SalesOrgVH',
        Label          : 'Sales Organization',
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'salesOrganization',
                ValueListProperty : 'SalesOrganization'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'distributionChannel',
                ValueListProperty : 'DistributionChannel'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'devision',
                ValueListProperty : 'Division'
            }
        ]
    }});
};

//Readonly and mandatory fields
annotate service.BillOfWorks {
    requestType              @readonly;
    SalesContract            @readonly;
    businessPartner          @readonly;
    contract                 @readonly;
    MaintenanceRevision      @readonly;
    MaintenancePlanningPlant @readonly;
    expectedArrivalDate      @readonly;
    expectedDeliveryDate     @readonly;
    functionalLocation       @readonly;
    equipment                @readonly
}
