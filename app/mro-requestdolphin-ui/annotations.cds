using from '../../srv/mro-requestdolphin-service';

annotate mrorequestdolphinService.MaintenanceRequests with @(UI : {
    //Selection Fields in Header of List Report Page
    SelectionFields                  : [
        requestNo,
        businessPartner1,
        expectedDeliveryDate,
        revisionNo
    ],
    //Line Item in List Report Page
    LineItem                         : [
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'mrorequestdolphinService.requestMail',
            Label  : '{i18n>requestMail}',
        },
        {Value : requestNo},
        {Value : requestDesc},
        {Value : businessPartner1},
        {Value : businessPartnerName1},
        {Value : expectedArrivalDate},
        {Value : expectedDeliveryDate},
        {Value : locationWC},
        {Value : locationWCPlant},
        {Value : equipment},
        {Value : equipmentName},
        {Value : functionalLocation},
        {Value : functionalLocationName},
        {Value : contract},
        {Value : revisionNo},
        //fields to be hidden in settings tab on list report page
        {
            Value : businessPartner,
            ![@UI.Hidden]
        },
        {
            Value : businessPartnerName,
            ![@UI.Hidden]
        },
        {
            Value : requestStatus1,
            ![@UI.Hidden]
        },
        {
            Value : requestType1,
            ![@UI.Hidden]
        },
        {
            Value : to_requestType_rType,
            ![@UI.Hidden],
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
            Value : listOfServices,
            ![@UI.Hidden]
        },
        {
            Value : to_botStatus_bStatus,
            ![@UI.Hidden]
        },
        {
            Value : mrCount,
            ![@UI.Hidden]
        },
        {
            Value : bpConcatenation,
            ![@UI.Hidden]
        }
    ],
    /*DataPoint                        : {
          $Type : 'UI.DataPointType',
          Value : {$edmJson : {
              $Apply    : [
                  {
                      $Path : 'requestNo',
                  },
                  {
                      $Path : 'requestDesc',
                  },
              ],
              $Function : 'odata.concat',
          }, },
      },*/

    //Sort the Request based on createdAt in list report page
    PresentationVariant              : {
        SortOrder      : [{
            $Type      : 'Common.SortOrderType',
            Property   : createdAt,
            Descending : true,
        }, ],
        Visualizations : ['@UI.LineItem']
    },

    //Header Information in Object Page
    HeaderInfo                       : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : '{i18n>Maintenance Request}',
        TypeNamePlural : '{i18n>Maintenance Requests}',
        Title          : {Value : requestNo},
        Description    : {Value : requestDesc}
    },
    //Header Facets Information in Object Page
    HeaderFacets                     : [
        {
            $Type  : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Basic1',
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Basic2'
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Detail'
        }
    ],
    //Column 1 for header facet
    FieldGroup #Basic2               : {Data : [
        {
            Value : createdAt,
            Label : '{i18n>createdAt}'
        },
        {
            Value : modifiedAt,
            Label : '{i18n>modifiedAt}'
        },
    ]},
    //Coulmn2 for header facet
    FieldGroup #Basic1               : {Data : [
        {
            Value : createdBy,
            Label : '{i18n>createdBy}'
        },
        {
            Value : modifiedBy,
            Label : '{i18n>modifiedBy}'
        }
    ]},

    //Column 3 for header facet
    FieldGroup #Detail               : {Data : [
        {
            Value                     : to_requestStatus_rStatus,
            Criticality               : criticalityLevel,
            CriticalityRepresentation : #WithoutIcon
        },
        {
            Value                     : to_requestPhase_rPhase,
            Criticality               : criticalityLevel,
            CriticalityRepresentation : #WithoutIcon

        }
    ]},

    //Tabs for facets on object page
    //There are two collection fields that's why ID is required at collection facet
    Facets                           : [
        //Tab 1 = General
        {
            $Type  : 'UI.CollectionFacet',
            Label  : '{i18n>General}',
            ID     : 'General',
            Facets : [
                {
                    //request desc and bp
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#group1',
                // Label  : '{i18n>group1}'
                },
                {
                    //start and end date
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#group2',
                // Label  : '{i18n>group2}'
                }
            ],
        },
        //Tab 2 = Asset Details
        {
            $Type  : 'UI.CollectionFacet',
            Label  : '{i18n>assetDetails}',
            ID     : 'assetDetails',
            Facets : [
                {
                    //Work Center details
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#group6',
                    Label  : '{i18n>group6}'
                },
                {
                    //Manufacturing details
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#group3',
                    Label  : '{i18n>group3}'
                },
                {
                    //floc and equip
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#group4',
                    Label  : '{i18n>group4}'
                },

            ],
        },
        //Tab 3 = Contracts
        {
            $Type  : 'UI.CollectionFacet',
            Label  : '{i18n>details}',
            ID     : 'details',
            Facets : [
                {
                    //contract details
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#group7',
                // Label  : '{i18n>group7}'
                },
                /*{
                     //expected arrival and delivery dates
                     $Type  : 'UI.ReferenceFacet',
                     Target : '@UI.FieldGroup#group5',
                 // Label  : '{i18n>group5}'
                 },*/
                {
                    //revision and list of services
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#group8',
                // Label  : '{i18n>group8}'
                },
            ],
        },
        //  Tab 4 = Documents
        {
            $Type  : 'UI.ReferenceFacet',
            Target : 'to_document/@UI.PresentationVariant',
            ID     : 'documents',
            Label  : '{i18n>documents}'
        },
    //Tab 5 = List of Services
    /* {
         $Type  : 'UI.ReferenceFacet',
         Target : 'to_listOfServices/@UI.PresentationVariant',
         ID     : 'listOfServices',
         Label  : '{i18n>listOfServices}'
     }*/
    ],

    FieldGroup #group1               : {Data : [
        {Value : requestDesc},
        {
            Value         : to_requestType_ID,
            ![@UI.Hidden] : uiHidden //Inital value in CREATE-> visible, In edit -> not visible
        },
        {
            Value         : requestType1,
            ![@UI.Hidden] : uiHidden1, //Inital value in CREATE-> not visible, In edit -> visible
        },
        {
            Value         : to_requestStatus_rStatus,
            ![@UI.Hidden] : uiHidden1 //Inital value in CREATE-> not visible, In edit -> visible
        },
        {
            Value         : requestStatus1,
            ![@UI.Hidden] : uiHidden, //Inital value in CREATE-> visible,  In edit -> not visible
        },
        {Value : businessPartner},
        {Value : businessPartnerName},
        {
            $Type  : 'UI.DataFieldForAnnotation',
            Target : '@UI.ConnectedFields#CustomerContact'
        }
    ]},
    FieldGroup #group2               : {Data : [
        {Value : startDate},
        {Value : endDate},
        {Value : to_botStatus_ID}
    ]},
    FieldGroup #group6               : {Data : [
        {Value : locationWC},
        {Value : locationWCDetail},
        {Value : locationWCPlant}
    ]},
    FieldGroup #group3               : {Data : [
        {Value : mName},
        {Value : mModel},
        {Value : mSerialNumber},
        {Value : eqMaterial},
        {Value : eqSerialNumber}
    ]},
    FieldGroup #group4               : {Data : [
        {Value : functionalLocation},
        {Value : functionalLocationName},
        {Value : equipment},
        {Value : equipmentName}
    ]},
    FieldGroup #group7               : {Data : [
        {Value : contract},
        {Value : contractName},
        {Value : expectedArrivalDate},
        {Value : expectedDeliveryDate},
    ]},
    /*  FieldGroup #group5               : {Data : [
                                                  // {Value : expectedArrivalDate},
                                                  // {Value : expectedDeliveryDate},
                                                 ]},*/
    FieldGroup #group8               : {Data : [{Value : revisionNo},
                                                                      //  {Value : listOfServices}
                                                         ]},

    //Connected fields for cutomer contact field
    ConnectedFields #CustomerContact : {
        Label    : 'Customer Contact',
        Template : '{Name}/{Email}/{PhoneNumber}',
        Data     : {
            Name        : {
                $Type : 'UI.DataField',
                Value : ccpersonName
            },
            Email       : {
                $Type : 'UI.DataField',
                Value : ccemail
            },
            PhoneNumber : {
                $Type : 'UI.DataField',
                Value : ccphoneNumber
            }
        }
    },
});

//Hide fields in Adapt filters on list report page
annotate mrorequestdolphinService.MaintenanceRequests with @Capabilities : {FilterRestrictions : {
    $Type                   : 'Capabilities.FilterRestrictionsType',
    NonFilterableProperties : [
        to_botStatus_ID,
        businessPartner,
        businessPartnerName,
        criticalityLevel,
        emailFlag,
        requestStatus1,
        requestType1,
        to_requestType_ID,
        uiHidden,
        uiHidden1,
        listOfServices,
        bpConcatenation,
        mrCount
    ]

}, };


//In list report page Request Description and request nummber will be concatenated
/*annotate mrorequestdolphinService.MaintenanceRequests with {
    requestDesc @(Common : {Text : {
        $value                 : requestNo,
        ![@UI.TextArrangement] : #TextLast
    }});
};

//In list report page Business partner will visible like this-> Ocenaic Airlines(101)
annotate mrorequestdolphinService.MaintenanceRequests with {
    businessPartner1 @(Common : {Text : {
        $value                 : businessPartnerName1,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//In list report page Work center plant and work center will be concatenated
annotate mrorequestdolphinService.MaintenanceRequests with {
    locationWC @(Common : {Text : {
        $value                 : locationWCPlant,
        ![@UI.TextArrangement] : #TextLast
    }});
};

//In list report page equipment name and equipment will be concatenated
annotate mrorequestdolphinService.MaintenanceRequests with {
    equipmentName @(Common : {Text : {
        $value                 : equipment,
        ![@UI.TextArrangement] : #TextLast
    }});
};

//In list report page equipment name and equipment will be concatenated
annotate mrorequestdolphinService.MaintenanceRequests with {
    functionalLocationName @(Common : {Text : {
        $value                 : functionalLocation,
        ![@UI.TextArrangement] : #TextLast
    }});
};

//In list report page contract name and contract will be concatenated
annotate mrorequestdolphinService.MaintenanceRequests with {
    contractName @(Common : {Text : {
        $value                 : contract,
        ![@UI.TextArrangement] : #TextLast
    }});
};*/

//text arrangment for request type e.g., -> 1(Complete Asset)
annotate mrorequestdolphinService.MaintenanceRequests with {
    requestType1 @(Common : {Text : {
        $value                 : to_requestType_rType,
        ![@UI.TextArrangement] : #TextLast,
    }});
};


//Hidden criteria after selecting request Type before create
/*annotate mrorequestdolphinService.MaintenanceRequests with @Common.SideEffects : {
    $Type            : 'Common.SideEffectsType',
    SourceProperties : [to_requestType_ID],
    TargetProperties : [
        mModel,
        mName,
        mSerialNumber,
        eqMaterial,
        eqSerialNumber,
        equipment
    ],
};*/

//Business partner value Help for list report page
annotate mrorequestdolphinService.MaintenanceRequests with {
    businessPartner1 @(Common : {ValueList : {
        CollectionPath  : 'BusinessPartnerVH',
        SearchSupported : true,
        Label           : '{i18n>businessPartner}',
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'businessPartner1',
                ValueListProperty : 'BusinessPartner'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'BusinessPartnerName'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'FirstName'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'LastName'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Description'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'SearchTerm1'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'SearchTerm2'
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

//Business partner value Help for object page
annotate mrorequestdolphinService.MaintenanceRequests with {
    businessPartner @(Common : {
                                /*Text      : {
                                    $value                 : businessPartnerName,
                                    ![@UI.TextArrangement] : #TextLast
                                },*/
                               ValueList : {
        CollectionPath : 'BusinessPartnerVH',
        Label          : '{i18n>businessPartner}',
        Parameters     : [
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
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'FirstName'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'LastName'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Description'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'SearchTerm1'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'SearchTerm2'
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

//Request Number value Help
annotate mrorequestdolphinService.MaintenanceRequests with {
    requestNo @(Common : {ValueList : {
        CollectionPath  : 'MaintenanceRequests',
        SearchSupported : true,
        Label           : '{i18n>requestNo}',
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'requestNo',
                ValueListProperty : 'requestNo'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'requestDesc'
            }
        ]
    }});
}

//Revision Number value Help
annotate mrorequestdolphinService.MaintenanceRequests with {
    revisionNo @(Common : {ValueList : {
        CollectionPath  : 'RevisionVH',
        SearchSupported : true,
        Label           : '{i18n>revisionNo}',
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'revisionNo',
                ValueListProperty : 'revisionNo'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'revisionText'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'revisionType'
            }
        ]
    }});
}

//Request Type as Drop down
annotate mrorequestdolphinService.MaintenanceRequests with {
    to_requestType @(Common : {
        Text      : {
            $value                 : to_requestType_rType,
            ![@UI.TextArrangement] : #TextLast
        },
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'RequestTypes',
            //  SearchSupported : true,
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

//Maintenance request status
annotate mrorequestdolphinService.MaintenanceRequests with {
    to_requestStatus @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'RequestStatuses',
            //  SearchSupported : true,
            Label          : '{i18n>requestStatus}',
            Parameters     : [{
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'to_requestStatus_rStatus',
                ValueListProperty : 'rStatus'
            }]
        }
    });
};

//Contract Value Help
annotate mrorequestdolphinService.MaintenanceRequests with {
    contract @(Common : {ValueList : {
        CollectionPath : 'SalesContractVH',
        Label          : '{i18n>contract}',
        //  SearchSupported : true,
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'businessPartner',
                ValueListProperty : 'SoldToPartyBP',
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'contract',
                ValueListProperty : 'SalesContract'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'contractName',
                ValueListProperty : 'SalesContractName'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'SalesContractName'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'TurnAroundTime'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'SoldToPartyBP'
            },
        ]
    }});
};

//Work Center Value help
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
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'WorkCenterCategoryCode'
            }
        ]
    }});
};

//Work center plant Value Help
annotate mrorequestdolphinService.MaintenanceRequests with {
    locationWCPlant @(Common : {ValueList : {
        CollectionPath  : 'WorkCenterVH',
        Label           : '{i18n>locationWCPlant}',
        SearchSupported : true,
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'locationWC',
                ValueListProperty : 'WorkCenter'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'locationWCPlant',
                ValueListProperty : 'Plant'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'WorkCenter'
            }
        ]
    }});
};

//Functional Location Value help
annotate mrorequestdolphinService.MaintenanceRequests with {
    functionalLocation @(Common : {ValueList : {
        CollectionPath  : 'FunctionLocationVH',
        SearchSupported : true,
        Label           : '{i18n>functionalLocation}',
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'locationWCPlant',
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
                ValueListProperty : 'ManufacturerSerialNumber'
            }
        ]
    }});
};

//Equipment Value help
annotate mrorequestdolphinService.MaintenanceRequests with {
    equipment @(Common : {ValueList : {
        CollectionPath  : 'EquipmentVH',
        SearchSupported : true,
        Label           : '{i18n>equipment}',
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'locationWCPlant',
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
                $Type             : 'Common.ValueListParameterDisplayOnly',
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

//Drop down for Bot Status
annotate mrorequestdolphinService.MaintenanceRequests with {
    to_botStatus @(Common : {
        Text      : {
            $value                 : to_botStatus_bStatus,
            ![@UI.TextArrangement] : #TextLast
        },
        Label     : '{i18n>botStatus}',
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'BotStatuses',
            //  SearchSupported : true,
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'to_botStatus_ID',
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'to_botStatus_bStatus',
                    ValueListProperty : 'bStatus'
                }
            ]
        }
    })
};

annotate mrorequestdolphinService.MaintenanceRequests {
    businessPartner        @mandatory;
    requestDesc            @mandatory;
    to_requestType         @mandatory;
    to_requestPhase        @mandatory;
    locationWC             @mandatory;
    locationWCPlant        @mandatory;
    revisionType           @readonly;
    revisionDescription    @readonly;
    businessPartnerName    @readonly;
    locationWCDetail       @readonly;
    // locationWCPlant        @Common : {FieldControl : #Inapplicable};
    equipmentName          @readonly;
    functionalLocationName @readonly;
    contractName           @readonly;
    requestType1           @readonly;
    requestStatus1         @readonly;
    revisionNo             @readonly;
}

annotate mrorequestdolphinService.Documents with @(UI : {
    LineItem            : [
        // {Value : ID},
        {
            Value : createdAt,
            Label : '{i18n>createdAt}'
        },
        {
            $Type : 'UI.DataFieldWithUrl',
            Value : url,
            Url   : url,

        /* ![@HTML5.CssDefaults] : {
             $Type : 'HTML5.CssDefaultsType',
             width : '50%',
         },*/
        },
        {Value : documentDesc}
    ],
    //It is used for setting the count for documents
    HeaderInfo          : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : '{i18n>documentLocation}',
        TypeNamePlural : '{i18n>documentLocations}'
    },
    PresentationVariant : {
        $Type          : 'UI.PresentationVariantType',
        Visualizations : [@UI.LineItem],
        SortOrder      : [{
            $Type      : 'Common.SortOrderType',
            Property   : createdAt,
            Descending : true,
        }]
    }
}, );


annotate mrorequestdolphinService.Documents {
    ID  @readonly;
    url @mandatory;
}
