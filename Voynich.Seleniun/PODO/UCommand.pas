unit UCommand;

interface

Uses Spring.Collections,
  System.Rtti,
  SysUtils;

Type

  TCommand = class
  private
    FGuid: TGUID;
    FAnonymousFunction: TFunc<string>;

  public
    Property Guid: TGUID Read FGuid Write FGuid;
    Property AnonymousFunction: TFunc<string> Read FAnonymousFunction Write FAnonymousFunction;

  end;

implementation

{ TCommand }

end.
