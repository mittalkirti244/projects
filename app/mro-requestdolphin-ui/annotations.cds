using from '../../srv/mro-requestdolphin-service';

annotate mrorequestdolphinService.MaintenanceRequests with @(UI : {
    //Selection Fields in Header of List Report Page
    SelectionFields                             : [
        requestNoConcat,
        to_requestType_rType,
        to_requestStatusDisp_rStatusDesc,
        to_requestPhase_rPhaseDesc,
        businessPartnerDisp,
        expectedDeliveryDate,
        MaintenanceRevision,
        to_ranges_range
    ],
    //Line Item in List Report Page
    LineItem                                    : [
        /* {
             $Type  : 'UI.DataFieldForAction',
             Action : 'mrorequestdolphinService.requestMail',
             Label  : '{i18n>requestMail}',
         },*/
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'mrorequestdolphinService.changeStatus',
            Label  : '{i18n>changeStatus}'
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'mrorequestdolphinService.revisionCreated',
            Label  : '{i18n>revisionCreated}'
        },
        {
            $Type           : 'UI.DataFieldForIntentBasedNavigation',
            Label           : '{i18n>CreateWorkItems}',
            SemanticObject  : 'MaintenanceWorkItem',
            Action          : 'manage',
            RequiresContext : true
        },
        {
            $Type           : 'UI.DataFieldForIntentBasedNavigation',
            Label           : '{i18n>CreateBOW}',
            SemanticObject  : 'MaintenanceWorkItem',
            Action          : 'manageBOW',
            RequiresContext : true
        },
        /*{
            $Type  : 'UI.DataFieldForAction',
            Action : 'mrorequestdolphinService.calculateAging',
            Label  : 'Generate Ageing'
        },*/
        {
            Value                 : requestNoConcat,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : to_requestType_rType,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : businessPartnerDisp,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : ccpersonName,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : ccemail,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : ccphoneNumber,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : to_requestStatusDisp_rStatusDesc,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : locationWC,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : MaintenancePlanningPlant,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : expectedArrivalDate,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : MaintenanceRevision,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : to_requestPhase_rPhaseDesc,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        //fields to be hidden in settings tab on list report page
        {
            Value : businessPartner,
            ![@UI.Hidden]
        },
        {
            Value : requestNo,
            ![@UI.Hidden]
        },
        {
            Value : businessPartnerName,
            ![@UI.Hidden]
        },
        {
            Value : businessPartnerNameDisp,
            ![@UI.Hidden]
        },
        {
            Value : requestTypeDisp,
            ![@UI.Hidden]
        },
        {
            Value : uiHidden,
            ![@UI.Hidden]
        },
        {
            Value : uiHidden1,
            ![@UI.Hidden]
        },
        {
            Value : criticalityLevel,
            ![@UI.Hidden]
        },
        {
            Value : emailFlag,
            ![@UI.Hidden]
        },
        {
            Value : mrCount,
            ![@UI.Hidden]
        },
        {
            Value : bpConcatenation,
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
            Value : contractName,
            ![@UI.Hidden]
        },
        {
            Value : locationWCDetail,
            ![@UI.Hidden]
        },
        {
            Value : createdAtDate,
            ![@UI.Hidden]
        },
        {
            Value : requestDesc,
            ![@UI.Hidden]
        },
        {
            Value : to_requestStatus_rStatus,
            ![@UI.Hidden]
        },
        {
            Value : to_requestStatus_rStatusDesc,
            ![@UI.Hidden]
        },
        {
            Value : to_requestStatusDisp_rStatus,
            ![@UI.Hidden]
        },
        {
            Value : to_requestPhase_rPhase,
            ![@UI.Hidden]
        },
        {
            Value : to_ranges_ID,
            ![@UI.Hidden]
        },
        {
            Value : changeStatusFlag,
            ![@UI.Hidden]
        },
        {
            Value : updateRevisionFlag,
            ![@UI.Hidden]
        },
        {
            Value : startDate,
            ![@UI.Hidden]
        },
        {
            Value : endDate,
            ![@UI.Hidden]
        }
    ],
    //Sort all Requests based on createdAt in list report page
    PresentationVariant                         : {
        SortOrder      : [{
            $Type      : 'Common.SortOrderType',
            Property   : createdAt,
            Descending : true,
        }, ],
        Visualizations : ['@UI.LineItem']
    },
    //Header Information in Object Page
    HeaderInfo                                  : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : '{i18n>requestForMaintenance}',
        TypeNamePlural : '{i18n>requestsForMaintenance}',
        Title          : {Value : requestNo},
        Description    : {Value : requestDesc}
    },
    //Header Facets Information in Object Page
    HeaderFacets                                : [
        {
            //Column 1 for header facet
            $Type  : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Basic1',
        },
        {
            //Column 2 for header facet
            $Type  : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Detail'
        },
        {
            //Column 3 for header facet
            $Type  : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Detail1'
        }
    ],
    //Coulmn 1 for header facet
    FieldGroup #Basic1                          : {Data : [
        {Value : to_requestType_rType},
        {Value : to_requestStatus_rStatusDesc},
        {Value : to_requestPhase_rPhaseDesc}
    ]},
    //Column 2 for header facet
    FieldGroup #Detail                          : {Data : [
        {Value : createdBy},
        {Value : modifiedBy}
    ]},
    //Column 3 for header facet
    FieldGroup #Detail1                         : {Data : [
        {Value : createdAt},
        {Value : modifiedAt}
    ]},

    //Tabs for facets on object page
    //There are two collection fields that's why ID is required at collection facet
    Facets                                      : [
        //Tab 1 = General
        {
            $Type  : 'UI.CollectionFacet',
            Label  : '{i18n>generalInformation}',
            ID     : 'generalInformation',
            Facets : [
                {
                    //Column 1 in General tab
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#generalGroup1',
                    Label  : '{i18n>generalGroup1}'
                },
                {
                    //Column 2 in General tab
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#generalGroup2',
                    Label  : '{i18n>generalGroup2}'
                },
                {
                    //Cloumn 3 in general tab
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#generalGroup3',
                    Label  : '{i18n>generalGroup3}'
                }
            ]
        },
        //Tab 2 = Asset Information
        {
            $Type  : 'UI.CollectionFacet',
            Label  : '{i18n>assetInformation}',
            ID     : 'assetInformation',
            Facets : [
                {
                    //Cloumn 1 of asset Information
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#locationGroup',
                    Label  : '{i18n>locationGroup}'
                },
                {
                    //Cloumn 2 of asset Information
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#referenceObjectsGroup',
                    Label  : '{i18n>referenceObjectsGroup}'
                },
                {
                    //Cloumn 3 of asset Information
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#additionalReferenceObjectsGroup',
                    Label  : '{i18n>additionalReferenceObjectsGroup}'
                }
            ]
        },
        //  Tab 3 = Documents
        {
            $Type  : 'UI.ReferenceFacet',
            Target : 'to_document/@UI.PresentationVariant',
            ID     : 'documents',
            Label  : '{i18n>documents}'
        }
    ],

    //Tab 1 - General Details
    //Column 1 in General tab
    FieldGroup #generalGroup1                   : {Data : [
        {Value : requestDesc},
        {Value : to_requestStatus_rStatusDesc,
                                               //![@UI.Hidden]             : uiHidden1, //Inital value in CREATE-> not visible, In edit -> visible
                                               // Criticality               : criticalityLevel,
                                               // CriticalityRepresentation : #WithoutIcon
                 },
        {Value : to_requestPhase_rPhaseDesc,
                                             //![@UI.Hidden]             : uiHidden1, //Inital value in CREATE-> not visible, In edit -> visible
                                             // Criticality               : criticalityLevel,
                                             // CriticalityRepresentation : #WithoutIcon
                 },
        {Value : modifiedBy,
                             //Label : '{i18n>modifiedBy}'
                 },
        {Value : modifiedAt,
                             //Label : '{i18n>modifiedAt}'
                 }
    ]},
    //Column 2 in General tab
    FieldGroup #generalGroup2                   : {Data : [
        {Value : businessPartner},
        {Value : ccpersonName},
        {Value : ccemail},
        {Value : ccphoneNumber},
        /*{
            $Type          : 'UI.DataFieldWithIntentBasedNavigation',
            //Label          : 'My Link for navigation',
            Value          : SalesContract,
            SemanticObject : 'SalesContract',
            Action         : 'manage'
        }*/
        {Value : SalesContract}
    ]},
    //Column 3 in general tab
    FieldGroup #generalGroup3                   : {Data : [
        {
            Value         : to_requestType_rType,
            ![@UI.Hidden] : uiHidden //Inital value in CREATE-> visible, In edit -> not visible
        },
        {
            Value         : requestTypeDisp,
            ![@UI.Hidden] : uiHidden1, //Inital value in CREATE-> not visible, In edit -> visible
        },
        {Value : locationWC},
        {Value : MaintenancePlanningPlant},
        {Value : expectedArrivalDate},
        {Value : expectedDeliveryDate},
    ]},

    //Tab 2 - Asset Information
    //Column 1 of asset information
    FieldGroup #locationGroup                   : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : mName},
            {Value : mModel},
            {Value : mPartNumber},
            {Value : mSerialNumber},
            {Value : eqMaterial},
            {Value : eqSerialNumber}
        ]
    },
    //Cloumn 2 of asset Information
    FieldGroup #referenceObjectsGroup           : {Data : [
        {Value : functionalLocation},
        {Value : equipment}
    ]},
    //Cloumn 3 of asset Information
    FieldGroup #additionalReferenceObjectsGroup : {Data : [{Value : MaintenanceRevision}]}
});

//Actions Defination
annotate mrorequestdolphinService.MaintenanceRequests with @(UI : {Identification : [
    {
        $Type  : 'UI.DataFieldForAction',
        Action : 'mrorequestdolphinService.changeStatus',
        Label  : '{i18n>changeStatus}'
    },
    {
        $Type  : 'UI.DataFieldForAction',
        Action : 'mrorequestdolphinService.revisionCreated',
        Label  : '{i18n>revisionCreated}'
    }
]});

//Text Arrangment
//Request nummber and request Description
annotate mrorequestdolphinService.MaintenanceRequests with {
    requestNoConcat @(Common : {Text : {
        $value                 : requestDesc,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text Arrangment for BP in List Page
annotate mrorequestdolphinService.MaintenanceRequests with {
    businessPartnerDisp @(Common : {Text : {
        $value                 : businessPartnerNameDisp,
        ![@UI.TextArrangement] : #TextFirst,
    }});
};

//Text Arrangment for BP in Object Page
annotate mrorequestdolphinService.MaintenanceRequests with {
    businessPartner @(Common : {Text : {
        $value                 : businessPartnerName,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text Arrangment for SalesContract and contract  name
annotate mrorequestdolphinService.MaintenanceRequests with {
    SalesContract @(Common : {Text : {
        $value                 : contractName,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

// Text Arrangment for Work center and work center Text
annotate mrorequestdolphinService.MaintenanceRequests with {
    locationWC @(Common : {Text : {
        $value                 : locationWCDetail,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

// annotate mrorequestdolphinService.WorkCenterVH with {
//     WorkCenter @(Common : {Text : {
//         $value                 : WorkCenterText,
//         ![@UI.TextArrangement] : #TextFirst
//     }});
// };

// Text Arrangment for Functional Location and Functional Location Name
annotate mrorequestdolphinService.MaintenanceRequests with {
    functionalLocation @(Common : {Text : {
        $value                 : functionalLocationName,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text Arrangment for Equipment and Equipment Name will be conactenated
annotate mrorequestdolphinService.MaintenanceRequests with {
    equipment @(Common : {Text : {
        $value                 : equipmentName,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text arrangement for plant and plant name
annotate mrorequestdolphinService.MaintenanceRequests with {
    MaintenancePlanningPlant @(Common : {Text : {
        $value                 : plantName,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text arrangement for Revision and Revision text on object page
/*annotate mrorequestdolphinService.MaintenanceRequests with {
    revision @(Common : {Text : {
        $value                 : revisionText,
        ![@UI.TextArrangement] : #TextFirst
    }});
};*/

//Text arrangement for Maintenance Revision and Revision text on object page
annotate mrorequestdolphinService.MaintenanceRequests with {
    MaintenanceRevision @(Common : {Text : {
        $value                 : revisionText,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text arrangement for Status field on List page
annotate mrorequestdolphinService.MaintenanceRequests with {
    to_requestStatusDisp_rStatusDesc @(Common : {Text : {
        $value                 : to_requestStatusDisp_rStatus,
        ![@UI.TextArrangement] : #TextLast
    }});
};

//Text arrangement for Status field on object page
annotate mrorequestdolphinService.MaintenanceRequests with {
    to_requestStatus_rStatusDesc @(Common : {Text : {
        $value                 : to_requestStatus_rStatus,
        ![@UI.TextArrangement] : #TextLast
    }});
};

//Text arrangemnt for Phase
annotate mrorequestdolphinService.MaintenanceRequests with {
    to_requestPhase_rPhaseDesc @(Common : {Text : {
        $value                 : to_requestPhase_rPhase,
        ![@UI.TextArrangement] : #TextLast
    }});
};

//Request Number Value help for List Page
annotate mrorequestdolphinService.MaintenanceRequests with {
    requestNoConcat @(Common : {ValueList : {
        CollectionPath  : 'MaintenanceRequestsDisp',
        SearchSupported : true,
        Label           : '{i18n>requestNo}',
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'requestNoConcat',
                ValueListProperty : 'requestNoConcat'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'requestDesc'
            }
        ]
    }});
};

//Business Partner Value help for list report page
annotate mrorequestdolphinService.MaintenanceRequests with {
    businessPartnerDisp @(Common : {ValueList : {
        CollectionPath  : 'BusinessPartnerVH',
        SearchSupported : true,
        Label           : '{i18n>businessPartner}',
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'businessPartnerDisp',
                ValueListProperty : 'BusinessPartner'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'BusinessPartnerName'
            },
            // {
            //     $Type             : 'Common.ValueListParameterDisplayOnly',
            //     ValueListProperty : 'BusinessPartnerRoleName'
            // },
            // {
            //     $Type             : 'Common.ValueListParameterDisplayOnly',
            //     ValueListProperty : 'SalesContract'
            // },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'businessPartnerRole',
                ValueListProperty : 'BusinessPartnerRoleName'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'SalesContract',
                ValueListProperty : 'SalesContract',
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'TurnAroundTime'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'ContactPersonName',
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'ContactPersonEmailID'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'TelephoneNo'
            }
        ]
    }});
};

//Business partner Value help for object page
annotate mrorequestdolphinService.MaintenanceRequests with {
    businessPartner @(Common : {ValueList : {
        CollectionPath  : 'BusinessPartnerVH',
        Label           : '{i18n>businessPartner}',
        SearchSupported : true,
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'businessPartner',
                ValueListProperty : 'BusinessPartner'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'businessPartnerName',
                ValueListProperty : 'BusinessPartnerName'
            },
            // {
            //     $Type             : 'Common.ValueListParameterDisplayOnly',
            //     ValueListProperty : 'BusinessPartnerRoleName'
            // },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'businessPartnerRole',
                ValueListProperty : 'BusinessPartnerRoleName'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'SalesContract',
                ValueListProperty : 'SalesContract',
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'TurnAroundTime'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'ccpersonName',
                ValueListProperty : 'ContactPersonName',
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'ccemail',
                ValueListProperty : 'ContactPersonEmailID'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'ccphoneNumber',
                ValueListProperty : 'TelephoneNo'
            }
        ]
    }});
};

//Revision Number Value help on object page
annotate mrorequestdolphinService.MaintenanceRequests with {
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
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'locationWC',
                ValueListProperty : 'WorkCenter'
            },
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

//Work Loacation Value help on object page
annotate mrorequestdolphinService.MaintenanceRequests with {
    locationWC @(Common : {ValueList : {
        CollectionPath  : 'WorkCenterVH',
        Label           : '{i18n>locationWC}',
        SearchSupported : true,
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'locationWC',
                ValueListProperty : 'WorkCenter'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'locationWCDetail',
                ValueListProperty : 'WorkCenterText'
            },
            // {
            //     $Type             : 'Common.ValueListParameterDisplayOnly',
            //     //LocalDataProperty : 'locationWCDetail',
            //     ValueListProperty : 'WorkCenterText'
            // },
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

//Functional Location Value help on object page
annotate mrorequestdolphinService.MaintenanceRequests with {
    functionalLocation @(Common : {ValueList : {
        CollectionPath  : 'FunctionLocationVH',
        SearchSupported : true,
        Label           : '{i18n>functionalLocation}',
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'MaintenancePlanningPlant',
                ValueListProperty : 'Plant'
            },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'mName',
                ValueListProperty : 'ManufacturerName'
            },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'mModel',
                ValueListProperty : 'ManufacturerPartTypeName'
            },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'mPartNumber',
                ValueListProperty : 'ManufacturerPartNmbr'
            },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'mSerialNumber',
                ValueListProperty : 'ManufacturerSerialNumber'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'functionalLocation',
                ValueListProperty : 'functionalLocation'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'functionalLocationName',
                ValueListProperty : 'FunctionalLocationName'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Plant'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'ManufacturerName'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'ManufacturerPartTypeName'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'ManufacturerPartNmbr'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'ManufacturerSerialNumber'
            }
        ]
    }});
};

//Equipment Value help on object page
annotate mrorequestdolphinService.MaintenanceRequests with {
    equipment @(Common : {ValueList : {
        CollectionPath  : 'EquipmentVH',
        SearchSupported : true,
        Label           : '{i18n>equipment}',
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'MaintenancePlanningPlant',
                ValueListProperty : 'Plant'
            },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'functionalLocation',
                ValueListProperty : 'FunctionalLocation'
            },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'eqMaterial',
                ValueListProperty : 'Material'
            },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'eqSerialNumber',
                ValueListProperty : 'SerialNumber'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'equipment',
                ValueListProperty : 'Equipment'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'equipmentName',
                ValueListProperty : 'EquipmentName'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Plant'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'functionalLocation',
                ValueListProperty : 'FunctionalLocation'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Material'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'SerialNumber'
            }
        ]
    }});
};

//Request Type Drop Down
annotate mrorequestdolphinService.MaintenanceRequests with {
    to_requestType @(Common : {
        /* Text      : {
             $value                 : to_requestType_rType,
             ![@UI.TextArrangement] : #TextFirst
         },*/
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'RequestTypes',
            Label          : '{i18n>requestType}',
            Parameters     : [
                              /*{
                                  $Type             : 'Common.ValueListParameterOut',
                                  LocalDataProperty : 'to_requestType_ID',
                                  ValueListProperty : 'ID'
                              },*/
                             {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'to_requestType_rType',
                ValueListProperty : 'rType'
            }]
        }
    })
};

//Request Status Drop Down on List Page
annotate mrorequestdolphinService.MaintenanceRequests with {
    to_requestStatusDisp_rStatusDesc @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'RequestStatusesDisp',
            Label          : '{i18n>requestStatus}',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterIn',
                    LocalDataProperty : 'to_requestStatusDisp_rStatus',
                    ValueListProperty : 'rStatus'
                },
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'to_requestStatusDisp_rStatusDesc',
                    ValueListProperty : 'rStatusDesc'
                }
            ]
        }
    });
};

//Request Phase Drop Down
annotate mrorequestdolphinService.MaintenanceRequests with {
    to_requestPhase_rPhaseDesc @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'RequestPhases',
            Label          : '{i18n>requestPhases}',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterIn',
                    LocalDataProperty : 'to_requestPhase_rPhase',
                    ValueListProperty : 'rPhase'
                },
                {
                    $Type             : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'to_requestPhase_rPhaseDesc',
                    ValueListProperty : 'rPhaseDesc'
                }
            ]
        }
    });
};

//Ranges Drop Down
annotate mrorequestdolphinService.MaintenanceRequests with {
    to_ranges @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'Ranges',
            //Label          : '{i18n>Range}',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterIn',
                    LocalDataProperty : 'to_ranges_ID',
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'to_ranges_range',
                    ValueListProperty : 'range'
                }
            ]
        }
    })
};

//Readonly and mandatory fields
annotate mrorequestdolphinService.MaintenanceRequests {
    businessPartner              @mandatory;
    requestDesc                  @mandatory;
    to_requestType               @mandatory;
    to_requestPhase_rPhaseDesc   @readonly;
    to_requestStatus_rStatusDesc @readonly;
    locationWC                   @mandatory;
    //MaintenancePlanningPlant @readonly;
    //MaintenancePlanningPlant @Common : {FieldControl : #Inapplicable};
    requestTypeDisp              @readonly;
}

//Hide fields in Adapt filters on list report page
annotate mrorequestdolphinService.MaintenanceRequests with @Capabilities : {FilterRestrictions : {
    $Type                   : 'Capabilities.FilterRestrictionsType',
    NonFilterableProperties : [
        businessPartner,
        businessPartnerName,
        businessPartnerNameDisp,
        criticalityLevel,
        emailFlag,
        requestTypeDisp,
        uiHidden,
        uiHidden1,
        bpConcatenation,
        mrCount,
        equipmentName,
        functionalLocationName,
        contractName,
        ccpersonName,
        ccphoneNumber,
        ccemail,
        requestDesc,
        mModel,
        mName,
        mPartNumber,
        mSerialNumber,
        eqMaterial,
        eqSerialNumber,
        locationWCDetail,
        revisionText,
        revisionType,
        requestNo,
        changeStatusFlag,
        updateRevisionFlag,
        requestTypeDisp,
        to_requestStatus_rStatus,
        to_requestStatus_rStatusDesc,
        to_requestStatusDisp_rStatus,
        to_requestPhase_rPhase,
        modifiedAt,
        modifiedBy,
        startDate,
        endDate
    ]
}};

//Details of Document tab
annotate mrorequestdolphinService.Documents with @(UI : {
    LineItem                  : [
        {
            Value                 : ID,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : documentName,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            $Type                 : 'UI.DataFieldWithUrl',
            Value                 : url,
            Url                   : url,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : to_typeOfAttachment_attachmentType,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : to_documentStatus_docStatusDesc,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : remarks,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : modifiedBy,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value                 : modifiedAt,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            }
        },
        {
            Value : eMailRecievedDateAndTime,
            ![@UI.Hidden]
        },
        {
            Value : fileFormatCheckRequired,
            ![@UI.Hidden]
        },
        {
            Value : formatCheck,
            ![@UI.Hidden]
        },
        {
            Value : eMailSent,
            ![@UI.Hidden]
        },
        {
            Value : workItemsCreated,
            ![@UI.Hidden]
        },
        {
            Value : to_typeOfAttachment_ID,
            ![@UI.Hidden]
        },
        {
            Value : to_documentStatus_ID,
            ![@UI.Hidden]
        },
        {
            Value : to_documentStatus_docStatus,
            ![@UI.Hidden]
        },
        {
            Value : to_maintenanceRequest_ID,
            ![@UI.Hidden]
        },
        {
            Value : UUID,
            ![@UI.Hidden]
        }
    ],
    //It is used for setting the count for documents
    HeaderInfo                : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : '{i18n>documentLocation}',
        TypeNamePlural : '{i18n>documentLocations}'
    },
    //Sort the list of documents by modified by
    PresentationVariant       : {
        $Type          : 'UI.PresentationVariantType',
        Visualizations : [@UI.LineItem],
        SortOrder      : [{
            $Type      : 'Common.SortOrderType',
            Property   : modifiedAt,
            Descending : true,
        }]
    },
    //Facets of Document on second object page
    Facets                    : [{
        $Type  : 'UI.ReferenceFacet',
        ID     : 'documentEntry',
        Target : '@UI.FieldGroup#documentEntry',
    }],
    FieldGroup #documentEntry : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : ID},
            {Value : documentName},
            {Value : url},
            {Value : to_typeOfAttachment_attachmentType},
            {Value : to_documentStatus_docStatusDesc},
            {Value : remarks}
        ]
    }
});

annotate mrorequestdolphinService.Documents {
    ID      @mandatory  @readonly;
    UUID    @readonly;
    remarks @UI.MultiLineText;
};

//Drop Down for Document status
annotate mrorequestdolphinService.Documents with {
    to_documentStatus @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'DocumentStatuses',
            Label          : '{i18n>to_documentStatus}',
            //  SearchSupported : true,
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterIn',
                    LocalDataProperty : 'to_documentStatus_docStatus',
                    ValueListProperty : 'docStatus'
                },
                {
                    $Type             : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'to_documentStatus_docStatusDesc',
                    ValueListProperty : 'docStatusDesc'
                }
            ]
        }
    })
};

//Drop Down for Attachment Type
annotate mrorequestdolphinService.Documents with {
    to_typeOfAttachment @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'AttachmentTypes',
            Label          : '{i18n>to_typeOfAttachment}',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterIn',
                    LocalDataProperty : 'to_typeOfAttachment_ID',
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'to_typeOfAttachment_attachmentType',
                    ValueListProperty : 'attachmentType'
                }
            ]
        }
    })
};
