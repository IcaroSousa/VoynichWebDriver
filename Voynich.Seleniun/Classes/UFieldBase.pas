unit UFieldBase;

interface
Uses System.Rtti,
  System.SysUtils,
  Spring.Collections,
  Vcl.Controls,
  vcl.Forms;

Type
TFieldBase = class(TInterfacedObject)

  private
    Function VisualComponentsPredicate(const pField: TRttiField): Boolean;
  protected
    Function FindElementField(pFormRttiType: TRttiType; pFieldName, pElementName: string): TRttiMember;
    Function FindRttiField(pFormRttiType: TRttiType; pFieldName: string): TRttiField;
  public

end;

implementation

{ TFieldBase }

function TFieldBase.FindElementField(pFormRttiType: TRttiType; pFieldName, pElementName: string): TRttiMember;
var
  _Field : TRttiField;
begin
  _Field := FindRttiField(pFormRttiType, pFieldName);

  if(_Field = nil)then
    raise Exception.Create(Format('The Field/Component -> %s cannot be found on -> %s', [pFieldName, pFormRttiType.ClassName]));

  Result := _Field.FieldType.GetMethod(pElementName) as TRttiMethod;
  if Result = nil then
      Result := _Field.FieldType.GetProperty(pElementName) as TRttiProperty;

end;

function TFieldBase.FindRttiField(pFormRttiType: TRttiType; pFieldName: string): TRttiField;
var
  _Fields: IList<TRttiField>;
  _VisualComponents: IEnumerable<TRttiField>;
begin

  _Fields := TCollections.CreateList<TRttiField>;
  _Fields.AddRange(pFormRttiType.GetFields);
  _VisualComponents := _Fields.Where(VisualComponentsPredicate);

  Result := _VisualComponents.Where
  (
    Function(Const pRttiField: TRttiField): Boolean
    begin
      Result := LowerCase(pRttiField.Name).Equals(LowerCase(pFieldName));
    end
  ).FirstOrDefault;

end;

function TFieldBase.VisualComponentsPredicate(const pField: TRttiField): Boolean;
begin

  Result := ((pField.FieldType is TRttiInstanceType) and (pField.Parent is TRttiInstanceType)) and
            TRttiInstanceType(pField.FieldType).MetaclassType.InheritsFrom(TControl) and
            TRttiInstanceType(pField.Parent).MetaclassType.InheritsFrom(TForm);
end;

end.
