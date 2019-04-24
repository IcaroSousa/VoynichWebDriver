unit UVoynichWebModule;

interface

uses System.SysUtils,
  System.Classes,
  Spring.Container,
  Spring.Collections,
  Web.HTTPApp,
  MVCFramework,
  UActionHandler,
  UFormHandler,
  UPropertyHandler,
  UActionHandlerInterface,
  UFormHandlerInterface,
  UPropertyHandleInterface,
  UCommand;

type
  TVoynichWebModule = class(TWebModule)
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    FMVC: TMVCEngine;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TVoynichWebModule;

implementation

{$R *.dfm}

uses UVoynichController, System.IOUtils, MVCFramework.Commons;

procedure TVoynichWebModule.WebModuleCreate(Sender: TObject);
begin

  GlobalContainer.RegisterInstance<IFormHandler>(TFormHandler.Create(), 'FormHandler');
  GlobalContainer.RegisterInstance<IActionHandler>(TActionHandler.Create, 'ActionHandler');
  GlobalContainer.RegisterInstance<IPropertyHandler>(TPropertyHandler.Create, 'PropertyHandler');
  GlobalContainer.RegisterInstance<IQueue<TCommand>>(TCollections.CreateQueue<TCommand>, 'CommandQueue');

  GlobalContainer.Build;

  FMVC := TMVCEngine.Create(Self,
    procedure(Config: TMVCConfig)
    begin
      Config[TMVCConfigKey.DocumentRoot] := TPath.Combine(ExtractFilePath(GetModuleName(HInstance)), 'www');
      Config[TMVCConfigKey.SessionTimeout] := '0';
      Config[TMVCConfigKey.DefaultContentType] := TMVCConstants.DEFAULT_CONTENT_TYPE;
      Config[TMVCConfigKey.DefaultContentCharset] := TMVCConstants.DEFAULT_CONTENT_CHARSET;
      Config[TMVCConfigKey.AllowUnhandledAction] := 'false';
      Config[TMVCConfigKey.DefaultViewFileExtension] := 'html';
      Config[TMVCConfigKey.ViewPath] := 'templates';
      Config[TMVCConfigKey.ExposeServerSignature] := 'true';
      Config[TMVCConfigKey.FallbackResource] := 'index.html';
    end);
  FMVC.AddController(TVoynichController);
end;

procedure TVoynichWebModule.WebModuleDestroy(Sender: TObject);
begin
  FMVC.Free;
end;

end.
