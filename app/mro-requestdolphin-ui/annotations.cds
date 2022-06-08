using from '../../srv/mro-requestdolphin-service';

annotate mrorequestdolphinService.MaintenanceRequests with @(UI : {
    //Selection Fields in Header of List Report Page
    SelectionFields                             : [
        requestNo,
        businessPartner1,
        expectedDeliveryDate,
        MaintenanceRevision
    ],
    //Line Item in List Report Page
    LineItem                                    : [
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'mrorequestdolphinService.requestMail',
            Label  : '{i18n>requestMail}',
        },
        {Value : requestNo},
        {Value : businessPartner1},
        {Value : expectedDeliveryDate},
        {Value : locationWC},
        {Value : to_requestStatus_rStatus},
        {Value : equipment},
        {Value : functionalLocation},
        {Value : contract},
        {Value : MaintenanceRevision},
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
            Value : businessPartnerName1,
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
        }
    ],
    //Sort the Request based on createdAt in list report page
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
        Description    : {Value : ''}
    },
    //Header Facets Information in Object Page
    HeaderFacets                                : [
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
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Revision'
        },
    /* {
         $Type  : 'UI.ReferenceFacet',
         Target : '@UI.Chart#Bulletchart',
     }*/
    ],
    //Column 1 for header facet
    FieldGroup #Basic2                          : {Data : [
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
    FieldGroup #Basic1                          : {Data : [
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
    FieldGroup #Detail                          : {Data : [
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

    //Column 4 for header facet (Revision Number)
    FieldGroup #Revision                        : {Data : [{
        Value : MaintenanceRevision,
        Label : '{i18n>MaintenanceRevision}'
    }]},

    //Tabs for facets on object page
    //There are two collection fields that's why ID is required at collection facet
    Facets                                      : [
        //Tab 1 = General
        {
            $Type  : 'UI.CollectionFacet',
            Label  : '{i18n>General}',
            ID     : 'General',
            Facets : [
                {
                    //request desc and bp
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#generalGroup1',
                // Label  : '{i18n>generalGroup1}'
                },
                {
                    //expexte arrival, delivey date and bot status
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#generalGroup2',
                // Label  : '{i18n>generalGroup2}'
                },
                {
                    //start and end date
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#generalGroup3',
                // Label  : '{i18n>generalGroup3}'
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
                    //Location
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#locationGroup',
                    Label  : '{i18n>locationGroup}'
                },
                {
                    //Reference Objects
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#referenceObjectsGroup',
                    Label  : '{i18n>referenceObjectsGroup}'
                },
                {
                    //Additional Reference Objects
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

    FieldGroup #generalGroup1                   : {Data : [
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
        }
    ]},

    FieldGroup #generalGroup2                   : {Data : [
        {Value : businessPartner},
        {
            $Type  : 'UI.DataFieldForAnnotation',
            Target : '@UI.ConnectedFields#CustomerContact'
        },
        {Value : contract}
    ]},

    FieldGroup #generalGroup3                   : {Data : [
        {Value : expectedArrivalDate},
        {Value : expectedDeliveryDate},
        {Value : to_botStatus_ID}
    ]},

    FieldGroup #locationGroup                   : {Data : [
        {Value : locationWC},
        {Value : MaintenancePlanningPlant}
    ]},
    FieldGroup #referenceObjectsGroup           : {Data : [
        {Value : mName},
        {Value : mModel},
        {Value : mPartNumber},
        {Value : mSerialNumber},
        {Value : functionalLocation}
    ]},
    FieldGroup #additionalReferenceObjectsGroup : {Data : [
        {Value : eqMaterial},
        {Value : eqSerialNumber},
        {Value : equipment}
    ]},

    //Connected fields for cutomer contact field
    ConnectedFields #CustomerContact            : {
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
    }
});

//Bullet Micro Chart for dates
/*annotate mrorequestdolphinService.MaintenanceRequests with @(UI : {Chart #Bulletchart : {
    $Type             : 'UI.ChartDefinitionType',
    ChartType         : #Bullet,
    Title             : 'Bullet Micro chart',
    //Description : 'REPLACE_WITH_CHART_DESCRIPTION',
    Measures          : [expectedArrivalDate],
    MeasureAttributes : [{
        Measure   : expectedArrivalDate,
        Role      : #Axis1,
        DataPoint : '@UI.DataPoint#BulletchartDatapoint'
    }]
}});

annotate mrorequestdolphinService.MaintenanceRequests with @(UI : {DataPoint #BulletchartDatapoint : {
    $Type         : 'UI.DataPointType',
    Value         : diffInCurrentAndArrivalDate,
    TargetValue   : diffInDeliveryAndArrivalDate,
    ForecastValue : foreCastDaysValue, //diffInDeliveryAndArrivalDate+10
    Criticality   : #Positive
// MinimumValue  : 0
}});*/

//Text Arrangment
//Request nummber and request Description  will be concatenated -> text(1001)
annotate mrorequestdolphinService.MaintenanceRequests with {
    requestNo @(Common : {Text : {
        $value                 : requestDesc,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text arrangment for request type e.g., -> 1(Complete Asset)
annotate mrorequestdolphinService.MaintenanceRequests with {
    requestType1 @(Common : {Text : {
        $value                 : to_requestType_rType,
        ![@UI.TextArrangement] : #TextLast,
    }});
};

//Text Arrangment for BP in List Page
annotate mrorequestdolphinService.MaintenanceRequests with {
    businessPartner1 @(Common : {Text : {
        $value                 : businessPartnerName1,
        ![@UI.TextArrangement] : #TextLast,
    }});
};

//Text Arrangment for BP in Object Page Ocenaic Airlines(101)
annotate mrorequestdolphinService.MaintenanceRequests with {
    businessPartner @(Common : {Text : {
        $value                 : businessPartnerName,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Text Arrangment for Revision and Revision Description
/*annotate mrorequestdolphinService.MaintenanceRequests with {
    MaintenanceRevision @(Common : {Text : {
        $value                 : revisionText,
        ![@UI.TextArrangement] : #TextFirst
    }});
};*/

//Text Arrangment for contract and contract  name will be concatenated
annotate mrorequestdolphinService.MaintenanceRequests with {
    contract @(Common : {Text : {
        $value                 : contractName,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

// Text Arrangment for Work center and work center Text will be concatenated
annotate mrorequestdolphinService.MaintenanceRequests with {
    locationWC @(Common : {Text : {
        $value                 : locationWCDetail,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

// Text Arrangment for Functional Location and Functional Location Name will be concatenated
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

//Business Partner1 value Help for list report page
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
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'businessPartnerName1',
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
    businessPartner @(Common : {ValueList : {
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

//Revision Number value Help
annotate mrorequestdolphinService.MaintenanceRequests with {
    MaintenanceRevision @(Common : {ValueList : {
        CollectionPath  : 'RevisionVH',
        SearchSupported : true,
        Label           : '{i18n>MaintenanceRevision}',
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'MaintenanceRevision',
                ValueListProperty : 'MaintenanceRevision'
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
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'MaintenancePlanningPlant',
                ValueListProperty : 'Plant'
            },

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

//Equipment Value help
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

//Request Type DropDown
annotate mrorequestdolphinService.MaintenanceRequests with {
    to_requestType @(Common : {
        Text      : {
            $value                 : to_requestType_rType,
            ![@UI.TextArrangement] : #TextLast
        },
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

//Request Status DropDown
annotate mrorequestdolphinService.MaintenanceRequests with {
    to_requestStatus @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'RequestStatuses',
            Label          : '{i18n>requestStatus}',
            Parameters     : [{
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'to_requestStatus_rStatus',
                ValueListProperty : 'rStatus'
            }]
        }
    });
};

//Bot Status DropDown
annotate mrorequestdolphinService.MaintenanceRequests with {
    to_botStatus @(Common : {
        Text      : {
            $value                 : to_botStatus_bStatus,
            ![@UI.TextArrangement] : #TextLast
        },
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'BotStatuses',
            Label          : '{i18n>botStatus}',
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

//Drop down for Processed By
annotate mrorequestdolphinService.Documents with {
    to_typeOfProcess @(Common : {
        Text      : {
            $value                 : to_typeOfProcess_processType,
            ![@UI.TextArrangement] : #TextLast
        },
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'ProcessTypes',
            Label          : '{i18n>to_typeOfProcess}',
            //  SearchSupported : true,
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'to_typeOfProcess_ID',
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'to_typeOfProcess_processType',
                    ValueListProperty : 'processType'
                }
            ]
        }
    })
};

//Drop down for Attachment Type
annotate mrorequestdolphinService.Documents with {
    to_typeOfAttachment @(Common : {
        Text      : {
            $value                 : to_typeOfAttachment_attachmentType,
            ![@UI.TextArrangement] : #TextLast
        },
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'AttachmentTypes',
            Label          : '{i18n>to_typeOfAttachment}',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'to_typeOfAttachment_ID',
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'to_typeOfAttachment_attachmentType',
                    ValueListProperty : 'attachmentType'
                }
            ]
        }
    })
};

annotate mrorequestdolphinService.MaintenanceRequests {
    businessPartner          @mandatory;
    requestDesc              @mandatory;
    to_requestType           @mandatory;
    to_requestPhase          @mandatory;
    locationWC               @mandatory;
    revisionType             @readonly;
    revisionDescription      @readonly;
    businessPartnerName      @readonly;
    locationWCDetail         @readonly;
    // MaintenancePlanningPlant        @readonly;
    MaintenancePlanningPlant @Common : {FieldControl : #Inapplicable};
    equipmentName            @readonly;
    functionalLocationName   @readonly;
    contractName             @readonly;
    requestType1             @readonly;
    requestStatus1           @readonly;
    MaintenanceRevision      @readonly;
}

//Hide fields in Adapt filters on list report page
annotate mrorequestdolphinService.MaintenanceRequests with @Capabilities : {FilterRestrictions : {
    $Type                   : 'Capabilities.FilterRestrictionsType',
    NonFilterableProperties : [
        to_botStatus_ID,
        businessPartner,
        businessPartnerName,
        businessPartnerName1,
        criticalityLevel,
        emailFlag,
        requestStatus1,
        requestType1,
        to_requestType_ID,
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
        revisionType
    ]
}, };


annotate mrorequestdolphinService.Documents with @(UI : {
    LineItem                  : [
        {Value : documentName},
        {
            $Type : 'UI.DataFieldWithUrl',
            Value : url,
            Url   : url,
        },
        {
            Value : createdAt,
            Label : '{i18n>createdAt}'
        },
        {Value : eMailRecievedDateAndTime},
        {Value : to_typeOfAttachment_ID},
        {Value : to_typeOfProcess_ID},
        {Value : fileFormatCheckRequired},
        {Value : formatCheck},
        {Value : eMailSent},
        {Value : workItemsCreated},
        {Value : remarks}
    ],
    //It is used for setting the count for documents
    HeaderInfo                : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : '{i18n>documentLocation}',
        TypeNamePlural : '{i18n>documentLocations}'
    },
    PresentationVariant       : {
        $Type          : 'UI.PresentationVariantType',
        Visualizations : [@UI.LineItem],
        SortOrder      : [{
            $Type      : 'Common.SortOrderType',
            Property   : createdAt,
            Descending : true,
        }]
    },
    Facets                    : [{
        $Type  : 'UI.ReferenceFacet',
        ID     : 'documentEntry',
        Target : '@UI.FieldGroup#documentEntry',
    }],
    FieldGroup #documentEntry : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : documentName},
            {Value : url},
            {
                Value : createdAt,
                Label : '{i18n>createdAt}'
            },
            {Value : eMailRecievedDateAndTime},
            {Value : to_typeOfAttachment_ID},
            {Value : to_typeOfProcess_ID},
            {Value : fileFormatCheckRequired},
            {Value : formatCheck},
            {Value : eMailSent},
            {Value : workItemsCreated},
            {Value : remarks}
        ]
    }
}, );

annotate mrorequestdolphinService.Documents {
    ID      @readonly;
    UUID    @readonly;
    url     @mandatory;
    remarks @UI.MultiLineText;
};
