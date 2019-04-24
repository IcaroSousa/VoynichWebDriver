unit UPropertyHandleInterface;

interface

Uses UFormHandlerInterface,
  System.Rtti;

Type

  IPropertyHandler = Interface
    ['{65FFFB03-ACDC-40E3-AF5A-87668366C728}']

    Procedure SetPropertyValue(pFormHandler: IFormHandler; pFormName, pFieldName, pPropertyName, pValue: string);
    Function GetPropertyValue(pFormHandler: IFormHandler; pFormName, pFieldName, pPropertyName: string): TValue;
  End;

implementation

end.
