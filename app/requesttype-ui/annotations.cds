using mrorequestdolphinService as service from '../../srv/mro-requestdolphin-service';

annotate service.RequestTypeConfig with @(UI : {
    SelectionFields             : [
        requestType,
        notificationType
    ],
    LineItem                    : [
        {
            $Type : 'UI.DataField',
            Value : requestType,
        },
        {
            $Type : 'UI.DataField',
            Value : notificationType,
        },
        {
            $Type : 'UI.DataField',
            Value : bowType,
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
                Value : requestType,
            },
            {
                $Type : 'UI.DataField',
                Value : notificationType,
            },
            {
                $Type : 'UI.DataField',
                Value : bowType,
            }
        ],
    },
    HeaderInfo                  : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : 'Request Type Details',
        TypeNamePlural : 'Request Types',
    //Title          : {Value : requestType},
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
    requestType @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'RequestTypes',
            Label          : '{i18n>requestType}',
            Parameters     : [{
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'requestType',
                ValueListProperty : 'rType'
            }]
        }
    })
};

annotate service.RequestTypeConfig with {
    notificationType @(Common : {
        ValueListWithFixedValues,
        ValueList : {
            CollectionPath : 'NotificationTypes',
            Label          : '{i18n>notificationType}',
            Parameters     : [{
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'notificationType',
                ValueListProperty : 'notifType'
            },
            // {
            //     $Type             : 'Common.ValueListParameterOut',
            //     LocalDataProperty : 'bowType',
            //     ValueListProperty : 'bowType'
            // }
            ]
        }
    })
};

//Text arrangement for Bow Type
annotate service.RequestTypeConfig with {
    bowType @(Common : {Text : {
        $value                 : bowTypeDesc,
        ![@UI.TextArrangement] : #TextFirst
    }});
};

annotate service.RequestTypeConfig with {
    requestType      @Common.FieldControl : #Mandatory;
    notificationType @Common.FieldControl : #Mandatory;
    bowType          @Common.FieldControl : #ReadOnly
};


annotate service.RequestTypeConfig with @Capabilities : {FilterRestrictions : {
    $Type                   : 'Capabilities.FilterRestrictionsType',
    NonFilterableProperties : [ID]
}};
