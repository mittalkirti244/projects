using mrorequestdolphinService as service from '../../srv/mro-requestdolphin-service';

annotate service.RequestTypeConfig with @(UI : {
    SelectionFields             : [
        to_requestType_rType,
        to_notificationType_notifType
    ],
    LineItem                    : [
        {
            $Type : 'UI.DataField',
            Value : to_requestType_rType,
        },
        {
            $Type : 'UI.DataField',
            Value : to_notificationType_notifType,
        },
        {
            $Type : 'UI.DataField',
            Value : to_notificationType.bowType,
        },
        {
            Value : ID,
            ![@UI.Hidden]
        },
        {
            Value : createdBy,
            ![@UI.Hidden]
        },
        {
            Value : modifiedBy,
            ![@UI.Hidden]
        },
        {
            Value : createdAt,
            ![@UI.Hidden]
        },
        {
            Value : modifiedAt,
            ![@UI.Hidden]
        },
    ],

    FieldGroup #GeneratedGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : to_requestType_rType,
            },
            {
                $Type : 'UI.DataField',
                Value : to_notificationType_notifType,
            },
            {
                $Type : 'UI.DataField',
                Value : to_notificationType.bowType,
            }
        ],
    },
    HeaderInfo                  : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : 'Request Type Details',
        TypeNamePlural : 'Request Types',
        //Title          : {Value : ID},
        //Description    : {Value : requestDesc}
    },
    HeaderFacets                : [
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
    FieldGroup #Detail          : {Data : [
        {Value : createdBy},
        {Value : modifiedBy}
    ]},
    //Column 3 for header facet
    FieldGroup #Detail1         : {Data : [
        {Value : createdAt},
        {Value : modifiedAt}
    ]},

    Facets                      : [{
        $Type  : 'UI.ReferenceFacet',
        ID     : 'GeneratedFacet1',
        Label  : 'General Information',
        Target : '@UI.FieldGroup#GeneratedGroup1',
    }, ]
});

annotate service.RequestTypeConfig with {
    to_requestType @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'RequestTypes',
            Label          : '{i18n>requestType}',
            Parameters     : [{
                $Type             : 'Common.ValueListParameterOut',
                LocalDataProperty : 'to_requestType_rType',
                ValueListProperty : 'rType'
            }]
        }
    })
};

annotate service.RequestTypeConfig with {
    to_notificationType @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'NotificationTypes',
            Label          : '{i18n>notificationType}',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'to_notificationType_notifType',
                    ValueListProperty : 'notifType'
                },
                // {
                //     $Type             : 'Common.ValueListParameterOut',
                //     LocalDataProperty : 'to_notificationType/bowType',
                //     ValueListProperty : 'bowType'
                // }
            ]
        }
    })
};


// annotate service.RequestTypeConfig with {
//     to_notificationType @(Common : {ValueList : {
//         CollectionPath  : 'NotificationTypes',
//         Label           : '{i18n>notificationType}',
//         SearchSupported : true,
//         Parameters      : [
//             {
//                 $Type             : 'Common.ValueListParameterInOut',
//                 LocalDataProperty : 'to_notificationType_notifType',
//                 ValueListProperty : 'notifType'
//             },
//             {
//                 $Type             : 'Common.ValueListParameterOut',
//                 LocalDataProperty : 'to_notificationType/bowType',
//                 ValueListProperty : 'bowType'
//             }
//         ]
//     }});
// };

annotate service.RequestTypeConfig with {
    to_requestType @Common.FieldControl : #Mandatory;
    to_notificationType @Common.FieldControl : #Mandatory
};

annotate service.NotificationTypes with {
    bowType @Common.FieldControl : #ReadOnly
};

annotate service.RequestTypeConfig with @Capabilities : {FilterRestrictions : {
    $Type                   : 'Capabilities.FilterRestrictionsType',
    NonFilterableProperties : [ID]
}};
