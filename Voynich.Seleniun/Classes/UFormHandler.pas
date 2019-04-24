unit UFormHandler;

interface

Uses UFormHandlerInterface,
  Spring.Collections,
  System.Classes,
  System.Rtti,
  System.Sysutils,
  vcl.Forms;

Type
  TFormHandler = class(TInterfacedObject, IFormHandler)
  private
    FRttiContext: TRttiContext;
    Function FormsContextPredicate(const pRttiType: TRttiType): Boolean;
    Function GetRttiTypeList: IEnumerable<TRttiType>;

  protected
    Procedure FormBuilder(pFormName: string); Overload;
    Procedure FormBuilder(pFormType: TRttiType); Overload;

  public
    Property RttiContext: TRttiContext Read FRttiContext;

    Procedure Initialize(pFormName: string);
    Procedure Finalize(pFormName: string);
    Function GetActiveForm: TForm;
    Function FindComponentInstanceInForm(pFormName, pComponentName: string): TComponent;

    Function FindRttiTypeForm(pFormName: string): TRttiType;
  end;

implementation

{ TFormHandler }

procedure TFormHandler.FormBuilder(pFormType: TRttiType);
var
  _Method: TRttiMethod;
  _Class: TClass;

  _ObjectForm: TObject;
  _Persistent: TPersistent;
begin

  _Method := pFormType.GetMethod('Create');
  _Class := TRttiInstanceType(pFormType).MetaclassType;

  _ObjectForm := _Method.Invoke(_Class, [Nil]).AsObject;
  _Persistent := TPersistent(_ObjectForm);
  TForm(_Persistent).Show;
end;


procedure TFormHandler.FormBuilder(pFormName: string);
var
  _Class: TClass;
  _Persistent: TPersistent;
begin
  _Class := GetClass(pFormName);
  _Persistent := TFormClass(_Class).Create(nil);
  TForm(_Persistent).Show;
end;

function TFormHandler.FormsContextPredicate(const pRttiType: TRttiType): Boolean;
begin
  Result := (pRttiType is TRttiInstanceType and TRttiInstanceType(pRttiType)
    .MetaclassType.InheritsFrom(TForm));

  if (pRttiType.Name = 'TForm') then
    Result := false;
end;

function TFormHandler.FindComponentInstanceInForm(pFormName, pComponentName: string): TComponent;
var
  _Form: TForm;
begin
  _Form := GetActiveForm as TForm;

  if not _Form.ClassName.Equals(pFormName) then
    raise Exception.Create(Format('The Form -> %s is not the active form! The active form is -> %s', [pFormName, _Form.ClassName]));

  Result := _Form.FindComponent(pComponentName);
end;

function TFormHandler.FindRttiTypeForm(pFormName: string): TRttiType;
begin

  Result := GetRttiTypeList.Where
  (
    Function(Const pFormRttiType: TRttiType): Boolean
    begin
      result := LowerCase(pFormRttiType.Name).Equals(LowerCase(pFormName));
    end
  ).FirstOrDefault;

end;

function TFormHandler.GetActiveForm: TForm;
begin
  Result := Screen.ActiveForm;
end;

function TFormHandler.GetRttiTypeList: IEnumerable<TRttiType>;
var
  _RttiTypeList: IList<TRttiType>;
begin

  _RttiTypeList := TCollections.CreateList<TRttiType>;
  _RttiTypeList.AddRange(FRttiContext.GetTypes);

  Result := _RttiTypeList.Where(FormsContextPredicate);
end;

procedure TFormHandler.Initialize(pFormName: string);
var
  _Type : TRttiType;
begin

  if GetRttiTypeList.Count <= 0 then
    raise Exception.Create('There are no forms registered..');

  _Type := FindRttiTypeForm(pFormName);
  FormBuilder(_Type);
end;


procedure TFormHandler.Finalize(pFormName: string);
var
  _Form: TForm;
begin
  _Form := GetActiveForm;
  _Form.Close;
  FreeAndNil(_Form);
end;

end.
