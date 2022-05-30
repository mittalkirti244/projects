using from './mro-requestdolphin-ui/annotations';

annotate mrorequestdolphinService.Documents with @(
    UI.HeaderInfo : {
        $Type : 'UI.HeaderInfoType',
        TypeName : '{i18n>UUID}',
        TypeNamePlural : '',
        Title : {Value : UUID},
    }
);
annotate mrorequestdolphinService.Documents with @(
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'General',
            ID : 'General',
            Target : '@UI.FieldGroup#General',
        },
    ],
    UI.FieldGroup #General : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : documentName,
            },
            {
                $Type : 'UI.DataField',
                Value : url,
            },
            {
                $Type : 'UI.DataField',
                Value : createdAt,
            },
            {
                $Type : 'UI.DataField',
                Value : eMailRecievedDateAndTime,
            },
            {
                $Type : 'UI.DataField',
                Value : to_typeOfAttachment_ID,
            },
            {
                $Type : 'UI.DataField',
                Value : to_typeOfProcess_ID,
            },
            {
                $Type : 'UI.DataField',
                Value : fileFormatCheckRequired,
            },
            {
                $Type : 'UI.DataField',
                Value : formatCheck,
            },
            {
                $Type : 'UI.DataField',
                Value : eMailSent,
            },
            {
                $Type : 'UI.DataField',
                Value : workItemsCreated,
            },
            {
                $Type : 'UI.DataField',
                Value : remarks,
            },],
    }
);

