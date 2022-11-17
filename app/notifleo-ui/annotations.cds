using mrorequestdolphinService as service from '../../srv/mro-requestdolphin-service';

annotate service.WorkItems with @(UI : {
    //Selection Fields in Header of List Report Page
    SelectionFields            : [
        requestNoConcat,
        MaintenanceNotification
    ],
    //Line Item in List Report Page
    LineItem                   : [
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'mrorequestdolphinService.assignTaskList',
            Label  : 'Assign Task List'
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'mrorequestdolphinService.createNotification',
            Label  : 'Generate Notification'
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
            Value                 : mrequestType,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            Value                 : MaintenanceNotification,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        // {
        //     $Type          : 'UI.DataFieldWithIntentBasedNavigation',
        //     //Label          : 'My Link for navigation',
        //     Value          : MaintenanceNotification,
        //     SemanticObject : 'MaintenanceNotification',
        //     Action         : 'displayNotification',
        // },
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
            Value : notificationFlag,
            ![@UI.Hidden]
        },
        {
            Value : unitOfMeasure,
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
            Value : ID,
            ![@UI.Hidden]
        },
        {
            Value : to_maintenanceRequest_ID,
            ![@UI.Hidden]
        },
        {
            Value : estimatedDueDate,
            ![@UI.Hidden]
        },
        {
            Value : to_typeOfLoad_ID,
            ![@UI.Hidden]
        },
        {
            Value : to_typeOfLoad_loadType,
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
        TypeName       : 'Work Item Details', //Label of object page
        TypeNamePlural : 'Work Items', //Label on list
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
                Label  : 'Work Item Information'
            },
            {
                $Type  : 'UI.ReferenceFacet',
                ID     : 'customerGroup2',
                Target : '@UI.FieldGroup#customerGroup2',
                Label  : 'Technical Reference'
            },
            {
                $Type  : 'UI.ReferenceFacet',
                ID     : 'customerGroup3',
                Target : '@UI.FieldGroup#customerGroup3',
                Label  : 'Additional Information'
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
            {Value : documentType},
            {Value : documentPart},
            {Value : documentVersion},
            {Value : MaintenanceNotification},
        /* {
             $Type          : 'UI.DataFieldWithIntentBasedNavigation',
             //Label          : 'My Link for navigation',
             Value          : MaintenanceNotification,
             SemanticObject : 'MaintenanceNotification',
             Action         : 'displayNotification',
         },*/

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
        Label  : 'Assign Task List'
    },
    {
        $Type  : 'UI.DataFieldForAction',
        Action : 'mrorequestdolphinService.createNotification',
        Label  : 'Generate Notification'
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
        Label          : 'Maintenance Request',
        SearchSupported : true,
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
                ValueListProperty : 'SalesContract'
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
        Label          : 'Maintenance Request',
        SearchSupported : true,
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
                ValueListProperty : 'SalesContract'
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
    MaintenanceNotification @(Common : {ValueList : {
        CollectionPath : 'MaintNotifications',
        Label          : 'Notification',
        SearchSupported : true,
        Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'MaintenanceNotification',
                ValueListProperty : 'MaintenanceNotification'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'NotificationText'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'NotificationType'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'MaintenanceWorkCenterPlant'
            },

            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'FunctionalLocation'
            },

            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Equipment'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Material'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'MaintenanceRevision'

            }
        ]
    }});
};

//TaskListType Value Help
annotate service.WorkItems with {
    taskListType @(Common : {ValueList : {
        CollectionPath : 'ReferenceTaskListVH',
        Label          : 'Task List Type',
        SearchSupported : true,
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
                ValueListProperty : 'MaintenancePlanningPlant'
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
                LocalDataProperty : 'documentType',
                ValueListProperty : 'DocumentInfoRecordDocType'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'documentNo',
                ValueListProperty : 'DocumentInfoRecordDocNumber'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'documentPart',
                ValueListProperty : 'DocumentInfoRecordDocPart'
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
                ValueListProperty : 'MaintenancePlanningPlant'
            }
        ]
    }});
};

//TaskListGroup Value Help
annotate service.WorkItems with {
    taskListGroup @(Common : {ValueList : {
        CollectionPath : 'ReferenceTaskListVH',
        Label          : 'Task List Group',
        SearchSupported : true,
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
                ValueListProperty : 'MaintenancePlanningPlant'
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
                LocalDataProperty : 'documentType',
                ValueListProperty : 'DocumentInfoRecordDocType'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'documentNo',
                ValueListProperty : 'DocumentInfoRecordDocNumber'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'documentPart',
                ValueListProperty : 'DocumentInfoRecordDocPart'
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
                ValueListProperty : 'MaintenancePlanningPlant'
            }
        ]
    }});
};

//TaskListGroup Counter Value Help
annotate service.WorkItems with {
    taskListGroupCounter @(Common : {ValueList : {
        CollectionPath : 'ReferenceTaskListVH',
        Label          : 'Task List Group Counter',
        SearchSupported : true,
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
                ValueListProperty : 'MaintenancePlanningPlant'
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
                LocalDataProperty : 'documentType',
                ValueListProperty : 'DocumentInfoRecordDocType'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'documentNo',
                ValueListProperty : 'DocumentInfoRecordDocNumber'
            },
            {
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'documentPart',
                ValueListProperty : 'DocumentInfoRecordDocPart'
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
                ValueListProperty : 'MaintenancePlanningPlant'
            }
        ]
    }});
};

//Drop down for WorkOrder Number
annotate service.WorkItems with {
    documentID @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'DocumentIDs',
            Label          : 'Document ID',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterIn',
                    LocalDataProperty : 'requestNo',
                    ValueListProperty : 'requestNoConcat'
                },
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'documentID',
                    ValueListProperty : 'documentID'
                }
            ]
        }
    });
};

annotate service.WorkItems {
    requestNo               @mandatory;
    requestNoDisp           @readonly;
    requestDesc             @readonly;
    taskListIdentifiedDate  @readonly;
    multiTaskListFlag       @readonly;
    MaintenanceNotification @readonly;
// mrequestType           @readonly;
// planningPlant          @readonly;
}

//Adapt Filters
annotate service.WorkItems with @Capabilities : {FilterRestrictions : {
    $Type                   : 'Capabilities.FilterRestrictionsType',
    NonFilterableProperties : [
        ID,
        requestNo,
        requestNoDisp,
        uiHidden,
        uiHidden1,
        workCenterDetail,
        businessPartner,
        businessPartnerName,
        requestDesc,
        quantity,
        unitOfMeasure,
        notificationFlag,
        contractName,
        equipmentName,
        revisionNo,
        mrequestStatus,
        workCenter,
        planningPlant,
        taskListFlag,
        notificationGenerateFlag,
        notificationUpdateFlag,
        assignTaskListFlag,
        to_maintenanceRequest_ID,
        estimatedDueDate,
        to_typeOfLoad_ID,
        to_typeOfLoad_loadType
    ]
}};
