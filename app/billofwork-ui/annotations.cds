using mrorequestdolphinService as service from '../../srv/mro-requestdolphin-service';

annotate service.BillOfWorks with @(UI : {
    //Selection Fields in Header of List Report Page
    SelectionFields          : [
        Bowid,
        requestNoConcat,
        MaintenanceRevision
    ],
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
            Value                 : requestNoConcat,
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
            Value                 : workLocation,
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
            Value                 : salesOrganization,
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
            Value                 : currency,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        //Hide fields from settings tab
        {
            Value : businessPartnerName,
            ![@UI.Hidden]
        },
        {
            Value : contractName,
            ![@UI.Hidden]
        },
        {
            Value : equipmentName,
            ![@UI.Hidden]
        },
        {
            Value : functionalLocationName,
            ![@UI.Hidden]
        },
        {
            Value : plantName,
            ![@UI.Hidden]
        },
        {
            Value : revisionText,
            ![@UI.Hidden]
        },
        {
            Value : workLocationDetail,
            ![@UI.Hidden]
        },
        {
            Value : to_maintenanceRequest_ID,
            ![@UI.Hidden]
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
        TypeName       : 'Manage Bill of Work', //Label of object page
        TypeNamePlural : 'Bill of Works', //Label on list
        Title          : {Value : Bowid},
        Description    : {Value : bowDesc}
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
                },
                {
                    $Type  : 'UI.ReferenceFacet',
                    ID     : 'mrInfo2',
                    Target : '@UI.FieldGroup#mrInfo2',
                },
                {
                    $Type  : 'UI.ReferenceFacet',
                    ID     : 'mrInfo3',
                    Target : '@UI.FieldGroup#mrInfo3',
                }
            ]
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
                },
                {
                    $Type  : 'UI.ReferenceFacet',
                    ID     : 'bowInfo2',
                    Target : '@UI.FieldGroup#bowInfo2',
                },
                {
                    $Type  : 'UI.ReferenceFacet',
                    ID     : 'bowInfo3',
                    Target : '@UI.FieldGroup#bowInfo3',
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
            {
                Value         : requestNoConcat, //this field will be used at the time of create
                ![@UI.Hidden] : uiHidden
            },
            {
                Value         : requestNoDisp, // this field will used at the time of edit (read only)
                ![@UI.Hidden] : uiHidden1
            },
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
            {Value : bowDesc},
        ]
    },
    FieldGroup #bowInfo2     : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : salesOrganization},
            {Value : distributionChannel},
            {Value : division}
        ]
    },
    FieldGroup #bowInfo3     : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : serviceProduct},
            {Value : standardProject}
        ]
    }
});

//Text arrangement
//Text arrangemennt for Request Number
annotate service.BillOfWorks with {
    requestNoConcat @(Common : {Text : {
        $value                 : requestDesc,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text arrangemennt for Request Number
annotate service.BillOfWorks with {
    requestNoDisp @(Common : {Text : {
        $value                 : requestDesc,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text arrangement for BOW
/*annotate service.BillOfWorks with {
    Bowid @(Common : {Text : {
        $value                 : bowDesc,
        ![@UI.TextArrangement] : #TextFirst
    }});
};*/

//Text arrangement for Business partner
annotate service.BillOfWorks with {
    businessPartner @(Common : {Text : {
        $value                 : businessPartnerName,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//text arrangement of sales contract
annotate service.BillOfWorks with {
    SalesContract @(Common : {Text : {
        $value                 : contractName,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text arrangement of Revision
annotate service.BillOfWorks with {
    MaintenanceRevision @(Common : {Text : {
        $value                 : revisionText,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text arrangement for Work Location
annotate service.BillOfWorks with {
    workLocation @(Common : {Text : {
        $value                 : workLocationDetail,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text arrangement of Plant
annotate service.BillOfWorks with {
    MaintenancePlanningPlant @(Common : {Text : {
        $value                 : plantName,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text arrangement of floc
annotate service.BillOfWorks with {
    functionalLocation @(Common : {Text : {
        $value                 : functionalLocationName,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text arrangement for equipment
annotate service.BillOfWorks with {
    equipment @(Common : {Text : {
        $value                 : equipmentName,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text arrangement for Bow Type
annotate service.BillOfWorks with {
    bowType @(Common : {Text : {
        $value                 : bowTypeDesc,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//value Help for Request Number
annotate service.BillOfWorks with {
    requestNoConcat @(Common : {ValueList : {
        CollectionPath : 'MaintenanceRequests',
        Label          : 'Maintenance Request',
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'requestNoConcat',
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

//value Help for sales Organization
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
                LocalDataProperty : 'division',
                ValueListProperty : 'Division'
            }
        ]
    }});
};

//value Help of service Product
annotate service.BillOfWorks with {
    serviceProduct @(Common : {ValueList : {
        CollectionPath : 'ServiceProducts',
        Label          : 'Service Products',
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'serviceProduct',
                ValueListProperty : 'Servicematerial'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'standardProject',
                ValueListProperty : 'Project'
            }
        ]
    }});
};

//Value help for currencies
annotate service.BillOfWorks with {
    currency @(Common : {ValueList : {
        CollectionPath : 'Currencies',
        Label          : 'Currency',
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'currency',
                ValueListProperty : 'Documentcurrency'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Currencyname'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Language'
            }
        ]
    }});
};

//Drop down for WorkOrder Number
annotate service.BillOfWorks with {
    workOrderNo @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'WorkOrderNumbers',
            Label          : 'Work Order Number',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterIn',
                    LocalDataProperty : 'requestNoConcat',
                    ValueListProperty : 'requestNoConcat'
                },
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'workOrderNo',
                    ValueListProperty : 'workOrderNo'
                }
            ]
        }
    });
};

//Value help for Work Location on object page
annotate service.BillOfWorks with {
    workLocation @(Common : {ValueList : {
        CollectionPath  : 'WorkCenterVH',
        Label           : '{i18n>locationWC}',
        SearchSupported : true,
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'workLocation',
                ValueListProperty : 'WorkCenter'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'workLocationDetail',
                ValueListProperty : 'WorkCenterText'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'WorkCenterCategoryCode'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'MaintenancePlanningPlant',
                ValueListProperty : 'Plant'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'plantName',
                ValueListProperty : 'PlantName'
            }
        ]
    }});
};

//Value help for Bill of Work on list report page
annotate service.BillOfWorks with {
    Bowid @(Common : {ValueList : {
        CollectionPath  : 'xHCLPRODSxC_Bow',
        Label           : 'Bill of Work',
        SearchSupported : true,
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'Bowid',
                ValueListProperty : 'Bowid'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Bowtxt'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'MaintenanceRevision'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'MaintenancePlanningPlant'
            }
        ]
    }});
};

//Revision Number Value help on object page
annotate service.BillOfWorks with {
    MaintenanceRevision @(Common : {ValueList : {
        CollectionPath  : 'RevisionVH',
        SearchSupported : true,
        Label           : '{i18n>MaintenanceRevision}',
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'MaintenanceRevision',
                ValueListProperty : 'RevisionNo'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'revisionText',
                ValueListProperty : 'RevisionText'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'RevisionType'
            },
            // {
            //     $Type             : 'Common.ValueListParameterIn',
            //     LocalDataProperty : 'locationWC',
            //     ValueListProperty : 'WorkCenter'
            // },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'MaintenancePlanningPlant',
                ValueListProperty : 'WorkCenterPlant'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'WorkCenter'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'WorkCenterPlant'
            }

        ]
    }});
}

//Readonly and mandatory fields
annotate service.BillOfWorks {
    requestNoConcat      @mandatory;
    workLocation         @mandatory;
    currency             @mandatory;
    salesOrganization    @mandatory;
    serviceProduct       @mandatory;
    requestNoDisp        @readonly;
    requestType          @readonly;
    SalesContract        @readonly;
    businessPartner      @readonly;
    contract             @readonly;
    MaintenanceRevision  @readonly;
    //MaintenancePlanningPlant @readonly;
    expectedArrivalDate  @readonly;
    expectedDeliveryDate @readonly;
    functionalLocation   @readonly;
    equipment            @readonly;
    distributionChannel  @readonly;
    standardProject      @readonly;
    division             @readonly;
    bowType              @readonly;
    bowDesc              @readonly;
}

//Hide fields in Adapt filters on list report page
annotate service.BillOfWorks with @Capabilities : {FilterRestrictions : {
    $Type                   : 'Capabilities.FilterRestrictionsType',
    NonFilterableProperties : [
        businessPartnerName,
        requestNoDisp,
        equipmentName,
        functionalLocationName,
        contractName,
        revisionText,
        modifiedAt,
        modifiedBy,
        plantName,
        revisionText,
        to_maintenanceRequest_ID,
        workLocationDetail,
        ID,
        requestDesc,
        expectedArrivalDate
    ]
}};
