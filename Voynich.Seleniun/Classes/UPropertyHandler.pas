unit UPropertyHandler;

interface

Uses UPropertyHandleInterface,
  UFormHandlerInterface,
  UFieldBase,
  System.Classes,
  System.Rtti,
  System.Sysutils,
  vcl.Forms;

Type
  TPropertyHandler = class(TFieldBase, IPropertyHandler)
  private


  protected
    Function FindProperty(pFormHandler: IFormHandler; pFormName, pFieldName, pPropertyName: string): TRttiProperty;

  public
    Procedure SetPropertyValue(pFormHandler: IFormHandler; pFormName, pFieldName, pPropertyName, pValue: string);
    Function GetPropertyValue(pFormHandler: IFormHandler; pFormName, pFieldName, pPropertyName: string): TValue;

  end;

implementation

{ TPropertyHandler }

function TPropertyHandler.FindProperty(pFormHandler: IFormHandler; pFormName, pFieldName, pPropertyName: string): TRttiProperty;
var
  _Form: TRttiType;
  _Property: TRttiProperty;
begin
  _Form := pFormHandler.FindRttiTypeForm(pFormName);
  _Property := FindElementField(_Form, pFieldName, pPropertyName) as TRttiProperty;

  if not Assigned(_Property) then
    raise Exception.Create(Format('Property -> %s cannot be found at -> %s!', [pPropertyName, pFormName]));

  Result := _Property;
end;

function TPropertyHandler.GetPropertyValue(pFormHandler: IFormHandler; pFormName, pFieldName, pPropertyName: string): TValue;
var
  _Property: TRttiProperty;
  _ComponentInstance: TComponent;
begin
  _Property := FindProperty(pFormHandler, pFormName, pFieldName, pPropertyName);
  _ComponentInstance := pFormHandler.FindComponentInstanceInForm(pFormName, pFieldName);

  Result := _Property.GetValue(_ComponentInstance);
end;

procedure TPropertyHandler.SetPropertyValue(pFormHandler: IFormHandler; pFormName, pFieldName, pPropertyName, pValue: string);
var
  _Property: TRttiProperty;
  _ComponentInstance: TComponent;
begin
  _Property := FindProperty(pFormHandler, pFormName, pFieldName, pPropertyName);
  _ComponentInstance := pFormHandler.FindComponentInstanceInForm(pFormName, pFieldName);

  _Property.SetValue(_ComponentInstance, TValue.From(pValue));
end;

end.
