unit UActionHandler;

interface

Uses UActionHandlerInterface,
  UFormHandlerInterface,
  UFieldBase,
  Spring.Collections,
  System.Rtti,
  System.Classes,
  System.SysUtils;

Type
  TActionHandler = class(TFieldBase, IActionHandler)
  private

  protected
    Function FindMethod(pFormHandler: IFormHandler; pFormName, pElementName, pActionName: string): TRttiMethod;

  public
    Procedure Perform(pFormHandler: IFormHandler; pFormName, pElementName, pActionName: string; pParams: TArray<TValue> = nil);

  end;

implementation

{ TActionHandler }

function TActionHandler.FindMethod(pFormHandler: IFormHandler; pFormName, pElementName, pActionName: string): TRttiMethod;
var
  _Form: TRttiType;
  _Method: TRttiMethod;
begin
  _Form := pFormHandler.FindRttiTypeForm(pFormName);
  _Method := FindElementField(_Form, pElementName, pActionName) as TRttiMethod;

  if not Assigned(_Method) then
    raise Exception.Create(Format('Method/Action -> %s cannot be found at -> %s!', [pActionName, pFormName]));

  Result := _Method;
end;

procedure TActionHandler.Perform(pFormHandler: IFormHandler; pFormName, pElementName, pActionName: string; pParams: TArray<TValue> = nil);
var
  _ComponentInstance: TComponent;
  _Method: TRttiMethod;
begin
  _Method := FindMethod(pFormHandler, pFormName, pElementName, pActionName);
  _ComponentInstance := pFormHandler.FindComponentInstanceInForm(pFormName, pElementName);

  _Method.Invoke(_ComponentInstance, pParams);
end;

end.
