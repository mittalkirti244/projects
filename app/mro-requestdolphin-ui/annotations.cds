using from '../../srv/mro-requestdolphin-service';

annotate mrorequestdolphinService.MaintenanceRequests with @(UI : {

    //Line Item in List Report Page
    LineItem                  : [{
        Value                 : to_requestType_rType,
        ![@HTML5.CssDefaults] : {
            $Type : 'HTML5.CssDefaultsType',
            width : '10rem',
        }
    }],
    //Sort all Requests based on createdAt in list report page
    PresentationVariant       : {
        SortOrder      : [{
            $Type      : 'Common.SortOrderType',
            Property   : createdAt,
            Descending : true,
        }, ],
        Visualizations : ['@UI.LineItem']
    },
    //Header Information in Object Page
    HeaderInfo                : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : '{i18n>requestForMaintenance}',
        TypeNamePlural : '{i18n>requestsForMaintenance}',
        //Title          : {Value : requestNo},
        Description    : {Value : requestDesc}
    },
    //Header Facets Information in Object Page
    HeaderFacets              : [
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
    FieldGroup #Basic1        : {Data : [{Value : to_requestType_rType}]},
    //Column 2 for header facet
    FieldGroup #Detail        : {Data : [
        {Value : createdBy},
        {Value : modifiedBy}
    ]},
    //Column 3 for header facet
    FieldGroup #Detail1       : {Data : [
        {Value : createdAt},
        {Value : modifiedAt}
    ]},

    //Tabs for facets on object page
    //There are two collection fields that's why ID is required at collection facet
    Facets                    : [{
        $Type  : 'UI.CollectionFacet',
        Label  : '{i18n>generalInformation}',
        ID     : 'generalInformation',
        Facets : [
            {
                //Column 1 in General tab
                $Type  : 'UI.ReferenceFacet',
                Target : '@UI.FieldGroup#generalGroup1',
            },
            {
                //Column 2 in General tab
                $Type  : 'UI.ReferenceFacet',
                Target : '@UI.FieldGroup#generalGroup2',
            },
            {
                //Cloumn 3 in general tab
                $Type  : 'UI.ReferenceFacet',
                Target : '@UI.FieldGroup#generalGroup3',
            }
        ]
    }],

    //Tab 1 - General Details
    //Column 1 in General tab
    FieldGroup #generalGroup1 : {Data : [{Value : requestDesc}]},
    //Column 2 in General tab
    FieldGroup #generalGroup2 : {Data : [{Value : businessPartner}, ]},
    //Column 3 in general tab
    FieldGroup #generalGroup3 : {Data : [{Value : to_requestType_rType, }]},
});

//Request Type Drop Down
annotate mrorequestdolphinService.MaintenanceRequests with {
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
