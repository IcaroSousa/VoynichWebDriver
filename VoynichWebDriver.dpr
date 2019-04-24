program VoynichWebDriver;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MVCFramework.Logger,
  MVCFramework.Commons,
  MVCFramework.REPLCommandsHandlerU,
  Web.ReqMulti,
  Web.WebReq,
  Web.WebBroker,
  IdHTTPWebBrokerBridge,
  UVoynichWebModule in 'Voynich.WebModule\WebModule\UVoynichWebModule.pas' {VoynichWebModule: TWebModule},
  UActionHandler in 'Voynich.Seleniun\Classes\UActionHandler.pas',
  UFieldBase in 'Voynich.Seleniun\Classes\UFieldBase.pas',
  UFormHandler in 'Voynich.Seleniun\Classes\UFormHandler.pas',
  UPropertyHandler in 'Voynich.Seleniun\Classes\UPropertyHandler.pas',
  UTakeScreenshot in 'Voynich.Seleniun\Classes\UTakeScreenshot.pas',
  UActionHandlerInterface in 'Voynich.Seleniun\Interfaces\UActionHandlerInterface.pas',
  UCommandInterface in 'Voynich.Seleniun\Interfaces\UCommandInterface.pas',
  UFormHandlerInterface in 'Voynich.Seleniun\Interfaces\UFormHandlerInterface.pas',
  UPropertyHandleInterface in 'Voynich.Seleniun\Interfaces\UPropertyHandleInterface.pas',
  UTakeScreenshotInterface in 'Voynich.Seleniun\Interfaces\UTakeScreenshotInterface.pas',
  UVoynichController in 'Voynich.WebModule\Controllers\UVoynichController.pas',
  UCommand in 'Voynich.Seleniun\PODO\UCommand.pas',
  UCommandFactory in 'Voynich.Seleniun\PODO\UCommandFactory.pas';

{$R *.res}

procedure StartRESTServer(APort: Integer);
var
  lServer: TIdHTTPWebBrokerBridge;
  lCustomHandler: TMVCCustomREPLCommandsHandler;
  lCmd: string;
begin

  if ParamCount >= 1 then
  begin
    lCmd := ParamStr(1);
  end
  else
  begin
    lCmd := 'start';
  end;

  lCustomHandler := function(const Value: String; const Server: TIdHTTPWebBrokerBridge; out Handled: Boolean): THandleCommandResult
    begin
      Handled := False;
      Result := THandleCommandResult.Unknown;
    end;

  lServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    lServer.DefaultPort := APort;

    { more info about MaxConnections
      http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_MaxConnections.html }
    lServer.MaxConnections := 0;

    { more info about ListenQueue
      http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_ListenQueue.html }
    lServer.ListenQueue := 200;

    WriteLn('Write "quit" or "exit" to shutdown the server');
    repeat
      if lCmd.IsEmpty then
      begin
        Write('-> ');
        ReadLn(lCmd)
      end;
      try
        case HandleCommand(lCmd.ToLower, lServer, lCustomHandler) of
          THandleCommandResult.Continue:
            begin
              Continue;
            end;
          THandleCommandResult.Break:
            begin
              Break;
            end;
          THandleCommandResult.Unknown:
            begin
              REPLEmit('Unknown command: ' + lCmd);
            end;
        end;
      finally
        lCmd := '';
      end;
    until False;

  finally
    lServer.Free;
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  IsMultiThread := True;
  try
    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := WebModuleClass;
    WebRequestHandlerProc.MaxConnections := 1024;
    StartRESTServer(4444);
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
