using mrorequestdolphinService as service from '../../srv/mro-requestdolphin-service';

annotate service.WorkItems with @(UI : {
    //Selection Fields in Header of List Report Page
    SelectionFields            : [
        requestNoConcat,
        notificationNoDisp
    ],
    //Line Item in List Report Page
    LineItem                   : [
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'mrorequestdolphinService.assignTaskList',
            Label  : '{i18n>assignTaskList}'
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'mrorequestdolphinService.createNotification',
            Label  : '{i18n>generatenotification}'
        },
        {
            Value                 : workItemID,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : workOrderNo,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : taskDescription,
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
            Value                 : to_maintenanceRequest.to_requestType_rType,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : notificationNoDisp,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : customerRef,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : genericRef,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : taskListType,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : taskListGroup,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : taskListGroupCounter,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },

        //Fields to hide in settings Tab
        {
            Value : to_typeOfLoad_ID,
            ![@UI.Hidden]
        },
        {
            Value : to_typeOfLoad_loadType,
            ![@UI.Hidden]
        },
        {
            Value : noOfAttachment,
            ![@UI.Hidden]
        },
        {
            Value : noOfEmail,
            ![@UI.Hidden]
        },
        {
            Value : requestNo,
            ![@UI.Hidden]
        },
        {
            Value : requestNoDisp,
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
            Value : billOfWorkDocRef,
            ![@UI.Hidden]
        },

        {
            Value : notificationFlag,
            ![@UI.Hidden]
        },

        {
            Value : quantity,
            ![@UI.Hidden]
        },
        {
            Value : unitOfMeasure,
            ![@UI.Hidden]
        },
        {
            Value : quotationDoc,
            ![@UI.Hidden]
        },
        {
            Value : requestDesc,
            ![@UI.Hidden]
        },
        {
            Value : taskListFlag,
            ![@UI.Hidden]
        },
        {
            Value : fileName,
            ![@UI.Hidden]
        },
        {
            Value : notificationUpdateFlag,
            ![@UI.Hidden]
        },
        {
            Value : notificationGenerateFlag,
            ![@UI.Hidden]
        },
        {
            Value : assignTaskListFlag,
            ![@UI.Hidden]
        },
        {
            Value : notificationNo,
            ![@UI.Hidden]
        },
        {
            Value : estimatedDueDate,
            ![@UI.Hidden]
        },
        {
            Value : ID,
            ![@UI.Hidden]
        }
    ],
    PresentationVariant        : {
        SortOrder      : [{
            $Type      : 'Common.SortOrderType',
            Property   : createdAt,
            Descending : true,
        }, ],
        Visualizations : ['@UI.LineItem']
    },
    //Header Information in Object Page
    HeaderInfo                 : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : '{i18n>workItemHeader}', //Label of object page
        TypeNamePlural : '{i18n>workItems}', //Label on list
        Title          : {Value : workItemID},
        Description    : {Value : taskDescription}
    },
    HeaderFacets               : [
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'basicDetail2',
            Target : '@UI.FieldGroup#basicDetail2',
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'basicDetail3',
            Target : '@UI.FieldGroup#basicDetail3',
        }
    ],
    //Facets Information in Object Page
    Facets                     : [{
        $Type  : 'UI.CollectionFacet',
        ID     : 'customerGroup',
        Facets : [
            {
                $Type  : 'UI.ReferenceFacet',
                ID     : 'customerGroup1',
                Target : '@UI.FieldGroup#customerGroup1',
                Label  : '{i18n>workItemInformation}'
            },
            {
                $Type  : 'UI.ReferenceFacet',
                ID     : 'customerGroup2',
                Target : '@UI.FieldGroup#customerGroup2',
                Label  : '{i18n>technicalReference}'
            },
            {
                $Type  : 'UI.ReferenceFacet',
                ID     : 'customerGroup3',
                Target : '@UI.FieldGroup#customerGroup3',
                Label  : '{i18n>additionalInformation}'
            },
        ],
    }, ],
    FieldGroup #basicDetail2   : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : createdBy},
            {Value : modifiedBy}
        ],
    },
    FieldGroup #basicDetail3   : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : createdAt},
            {Value : modifiedAt}
        ]
    },

    //Tab 2 = Customer Information Field Group
    FieldGroup #customerGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                Value         : requestNo, //this field will be used at the time of create
                ![@UI.Hidden] : uiHidden
            },
            {
                Value         : requestNoDisp, // this field will used at the time of edit (read only)
                ![@UI.Hidden] : uiHidden1
            },
            {Value : mrequestType},
            {Value : planningPlant},
            {Value : workOrderNo},
            {Value : sequenceNo},
            {Value : taskDescription},
            {Value : customerRef},
            {Value : genericRef}
        ],
    },
    FieldGroup #customerGroup2 : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : taskListType},
            {Value : taskListGroup},
            {Value : taskListGroupCounter},
            {Value : taskListDescription},
            {Value : multiTaskListFlag},
            {Value : taskListIdentifiedDate},
            {Value : documentNo},
            {Value : documentVersion},
            {Value : notificationNo}
        ],
    },
    FieldGroup #customerGroup3 : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : documentID},
            {Value : additionalRemark}
        ]
    }
});

annotate service.WorkItems with @(UI : {Identification : [
    {
        $Type  : 'UI.DataFieldForAction',
        Action : 'mrorequestdolphinService.assignTaskList',
        Label  : '{i18n>assignTaskList}'
    },
    {
        $Type  : 'UI.DataFieldForAction',
        Action : 'mrorequestdolphinService.createNotification',
        Label  : '{i18n>generatenotification}'
    }
]});

annotate service.WorkItems with {
    requestNoConcat @(Common : {Text : {
        $value                 : requestDesc,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

annotate service.WorkItems with {
    requestNo @(Common : {Text : {
        $value                 : requestDesc,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

annotate service.WorkItems with {
    requestNoDisp @(Common : {Text : {
        $value                 : requestDesc,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

//Request Number value help on object page
annotate service.WorkItems with {
    requestNo @(Common : {ValueList : {
        CollectionPath : 'MaintenanceRequests',
        Label          : '{i18n>requestNo}',
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'requestNo',
                ValueListProperty : 'requestNo'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'requestDesc'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'mrequestType',
                ValueListProperty : 'to_requestType_rType'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'mrequestStatus',
                ValueListProperty : 'to_requestStatusDisp_rStatusDesc'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'locationWC'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'locationWCDetail'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'planningPlant',
                ValueListProperty : 'MaintenancePlanningPlant'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'contract'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'contractName'
            },

            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'functionalLocation'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'functionalLocationName'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'equipment'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'equipmentName'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'MaintenanceRevision'
            }
        ]
    }});
};

//Request Number Value Help Filter for list report page
annotate service.WorkItems with {
    requestNoConcat @(Common : {ValueList : {
        CollectionPath : 'MaintenanceRequests',
        Label          : '{i18n>requestNo}',
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'requestNoConcat',
                ValueListProperty : 'requestNo'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'requestDesc'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'to_requestType_rType'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'locationWC'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'locationWCDetail'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'MaintenancePlanningPlant'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'contract'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'contractName'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'functionalLocation'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'functionalLocationName'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'equipment'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'equipmentName'
            },
            {
                $Type             : 'Common.ValueListParameterFilterOnly',
                ValueListProperty : 'MaintenanceRevision'
            }

        ]
    }});
};

//Notification Number Value Help Filter for list report page
annotate service.WorkItems with {
    notificationNoDisp @(Common : {ValueList : {
        CollectionPath : 'NotificationVH',
        Label          : '{i18n>notificationNo}',
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'notificationNoDisp',
                ValueListProperty : 'notificationNoDisp'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'requestNo'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'planningPlant'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'functionalLocation'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'material'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'equipment'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'revisionNo'
            }
        ]
    }});
};

//TaskListType Value Help
annotate service.WorkItems with {
    taskListType @(Common : {ValueList : {
        CollectionPath : 'ReferenceTaskListVH',
        Label          : '{i18n>taskListType}',
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'genericRef',
                ValueListProperty : 'ExternalReference'
            },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'customerRef',
                ValueListProperty : 'ExternalCustomerReference'
            },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'planningPlant',
                ValueListProperty : 'Plant'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'taskListType',
                ValueListProperty : 'TaskListType'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'taskListGroup',
                ValueListProperty : 'TaskListGroup'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'taskListGroupCounter',
                ValueListProperty : 'TaskListGroupCounter'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'taskListDescription',
                ValueListProperty : 'TaskListDesc'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'documentNo',
                ValueListProperty : 'DocumentInfoRecordDocNumber'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'documentVersion',
                ValueListProperty : 'DocumentInfoRecordDocVersion'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'ExternalCustomerReference'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'ExternalReference'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Plant'
            }
        ]
    }});
};

//TaskListGroup Value Help
annotate service.WorkItems with {
    taskListGroup @(Common : {ValueList : {
        CollectionPath : 'ReferenceTaskListVH',
        Label          : '{i18n>taskListGroup}',
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'genericRef',
                ValueListProperty : 'ExternalReference'
            },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'customerRef',
                ValueListProperty : 'ExternalCustomerReference'
            },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'planningPlant',
                ValueListProperty : 'Plant'
            },
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'taskListType',
                ValueListProperty : 'TaskListType'
            },
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'taskListGroup',
                ValueListProperty : 'TaskListGroup'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'taskListGroupCounter',
                ValueListProperty : 'TaskListGroupCounter'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'taskListDescription',
                ValueListProperty : 'TaskListDesc'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'documentNo',
                ValueListProperty : 'DocumentInfoRecordDocNumber'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'documentVersion',
                ValueListProperty : 'DocumentInfoRecordDocVersion'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'ExternalCustomerReference'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'ExternalReference'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Plant'
            }
        ]
    }});
};

//TaskListGroup Counter Value Help
annotate service.WorkItems with {
    taskListGroupCounter @(Common : {ValueList : {
        CollectionPath : 'ReferenceTaskListVH',
        Label          : '{i18n>taskListGroupCounter}',
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'genericRef',
                ValueListProperty : 'ExternalReference'
            },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'customerRef',
                ValueListProperty : 'ExternalCustomerReference'
            },
            {
                $Type             : 'Common.ValueListParameterIn',
                LocalDataProperty : 'planningPlant',
                ValueListProperty : 'Plant'
            },
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'taskListType',
                ValueListProperty : 'TaskListType'
            },
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'taskListGroup',
                ValueListProperty : 'TaskListGroup'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'taskListGroupCounter',
                ValueListProperty : 'TaskListGroupCounter'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'taskListDescription',
                ValueListProperty : 'TaskListDesc'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'documentNo',
                ValueListProperty : 'DocumentInfoRecordDocNumber'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'documentVersion',
                ValueListProperty : 'DocumentInfoRecordDocVersion'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'ExternalCustomerReference'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'ExternalReference'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Plant'
            }
        ]
    }});
};

//Drop Down for typeOfLoad(Data Upload Process)
annotate service.WorkItems with {
    to_typeOfLoad @(Common : {
        Text      : {
            $value                 : to_typeOfLoad_loadType,
            ![@UI.TextArrangement] : #TextFirst
        },
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'TypeOfLoads',
            Label          : '{i18n>unitOfMeasure}',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'to_typeOfLoad_ID',
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'to_typeOfLoad_loadType',
                    ValueListProperty : 'loadType'
                }
            ]
        }
    });
};

annotate service.WorkItems {
    requestNo              @mandatory;
    //mrequestType           @readonly;
    requestNoDisp          @readonly;
    requestDesc            @readonly;
    billOfWorkDocRef       @readonly;
    quotationDoc           @readonly;
    taskListIdentifiedDate @readonly;
    multiTaskListFlag      @readonly;
    notificationNo         @readonly;
//planningPlant          @readonly;
}

//Adapt Filters
annotate service.WorkItems with @Capabilities : {FilterRestrictions : {
    $Type                   : 'Capabilities.FilterRestrictionsType',
    NonFilterableProperties : [
        ID,
        functionalLocation,
        functionalLocationName,
        equipment,
        contractName,
        to_typeOfLoad_ID,
        to_typeOfLoad_loadType,
        requestNo,
        requestNoDisp,
        uiHidden,
        uiHidden1,
        workCenterDetail,
        billOfWorkDocRef,
        businessPartner,
        businessPartnerName,
        requestDesc,
        noOfAttachment,
        noOfEmail,
        quantity,
        unitOfMeasure,
        notificationFlag,
        quotationDoc,
        contractName,
        contractNo,
        equipmentName,
        revisionNo,
        mrequestStatus,
        workCenter,
        planningPlant,
        taskListFlag,
        fileName,
        notificationGenerateFlag,
        notificationUpdateFlag,
        assignTaskListFlag,
        notificationNo,
        estimatedDueDate
    ]
}};