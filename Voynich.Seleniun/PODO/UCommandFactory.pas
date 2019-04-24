unit UCommandFactory;

interface

Uses UCommand,
  Spring.Collections,
  System.Rtti,
  SysUtils;

Type
  TCommandFactory = class
  Protected
    FCommand: TCommand;
  Public
    Function SetGuid(pGuid: TGUID): TCommandFactory;
    Function SetAnonymousFunction(pFunc: TFunc<string>): TCommandFactory;

    Function Build: TCommand;
    Constructor Create();
  end;

implementation

{ TCommandFacotry }

function TCommandFactory.Build: TCommand;
begin
  Result := FCommand;
end;

constructor TCommandFactory.Create;
var
  _Guid: TGuid;
begin
  CreateGUID(_Guid);

  FCommand := TCommand.Create;
  FCommand.Guid := _Guid;
end;

function TCommandFactory.SetAnonymousFunction(pFunc: TFunc<string>): TCommandFactory;
begin
  FCommand.AnonymousFunction := pFunc;
  Result := Self;
end;

function TCommandFactory.SetGuid(pGuid: TGUID): TCommandFactory;
begin
  FCommand.Guid := pGuid;
  Result := Self;
end;

end.
