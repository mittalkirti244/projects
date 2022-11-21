using mrorequestdolphinService as service from '../../srv/mro-requestdolphin-service';

annotate service.WorkItems with @(UI : {
    //Line Item in List Report Page
    LineItem                   : [
        {
            Value                 : mrequestType,
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
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
            }
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
            {Value : to_maintenanceRequest.to_requestType_rType}
        ],
    }
});