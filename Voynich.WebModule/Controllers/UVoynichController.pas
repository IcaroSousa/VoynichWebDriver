unit UVoynichController;

interface

uses
  MVCFramework, MVCFramework.Commons,
  Spring.Reflection, Spring.Container,
  Spring.utils, Spring.Collections,
  System.Rtti, System.classes, System.SysUtils,
  UActionHandler, UFormHandler, UPropertyHandler,
  UActionHandlerInterface, UFormHandlerInterface, UPropertyHandleInterface,
  UCommand, UCommandFactory;

type

  [MVCPath('/wd')]
  TVoynichController = class(TMVCController)
  protected
    procedure PrepareAction(pFunc: TFunc<string>);

    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public

    FPropertyHandle: IPropertyHandler;
    FActionHandler: IActionHandler;
    FFormHandler: IFormHandler;

    [MVCPath('/')]
    [MVCHTTPMethod([httpGET])]
    procedure Index;

    [MVCPath('/ExecuteTest')]
    [MVCHTTPMethod([httpGET])]
    procedure ExecuteTest;

    [MVCPath('/InitializeForm/($formname)')]
    [MVCHTTPMethod([httpGET])]
    procedure Initialize(formname: string);

    [MVCPath('/FinalizeForm/($formname)')]
    [MVCHTTPMethod([httpGET])]
    procedure Finalize(formname: string);

    [MVCPath('/DblClickAt/($formname)/($elementname)')]
    [MVCHTTPMethod([httpGET])]
    procedure DblClickAt(formname, elementname: string);

    [MVCPath('/ClickAt/($formname)/($elementname)')]
    [MVCHTTPMethod([httpGET])]
    procedure ClickAt(formname, elementname: string);

    [MVCPath('/SetTextTo/($formname)/($elementname)')]
    [MVCHTTPMethod([httpGET])]
    procedure SetTextTo(formname, elementname, value: string);

    [MVCPath('/GetTextFrom/($formname)/($elementname)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetTextFrom(formname, elementname: string);

    [MVCPath('/WaitUntilElementIsVisible/($formname)/($elementname)')]
    [MVCHTTPMethod([httpGET])]
    procedure WaitUntilElementIsVisible(formname, elementname: string);

    [MVCPath('/WaitUntilElementIsActive/($formname)/($elementname)')]
    [MVCHTTPMethod([httpGET])]
    procedure WaitUntilElementIsActive(formname, elementname: string);

  end;

implementation

uses
  MVCFramework.Logger, System.StrUtils;

procedure TVoynichController.Index;
begin
  Render('Hey.. Welcome to the Voynich Web Driver');
end;

procedure TVoynichController.OnAfterAction(Context: TWebContext;
const AActionName: string);
begin
  inherited;
end;

procedure TVoynichController.OnBeforeAction(Context: TWebContext;
const AActionName: string; var Handled: Boolean);
begin

  inherited;
end;

procedure TVoynichController.Initialize(formname: string);
begin
  PrepareAction(
    Function(): string
    var
      _FormHandler: IFormHandler;
    begin
      _FormHandler := GlobalContainer.Resolve<IFormHandler>('FormHandler');
      _FormHandler.Initialize(formname);
    end);
end;

procedure TVoynichController.Finalize(formname: string);
begin
  PrepareAction(
    Function(): string
    var
      _FormHandler: IFormHandler;
    begin
      _FormHandler := GlobalContainer.Resolve<IFormHandler>('FormHandler');
      _FormHandler.Finalize(formname);
    end);
end;

procedure TVoynichController.ClickAt(formname, elementname: string);
begin
  PrepareAction(
    Function(): string
    var
      _ActionHandle: IActionHandler;
      _FormHandler: IFormHandler;
    begin
      _ActionHandle := GlobalContainer.Resolve<IActionHandler>('ActionHandler');
      _FormHandler := GlobalContainer.Resolve<IFormHandler>('FormHandler');
      _ActionHandle.Perform(_FormHandler, formname, elementname, 'Click');
    end);
end;

procedure TVoynichController.DblClickAt(formname, elementname: string);
begin
  PrepareAction(
    Function(): string
    var
      _ActionHandle: IActionHandler;
      _FormHandler: IFormHandler;
    begin
      _ActionHandle := GlobalContainer.Resolve<IActionHandler>('ActionHandler');
      _FormHandler := GlobalContainer.Resolve<IFormHandler>('FormHandler');
      _ActionHandle.Perform(_FormHandler, formname, elementname, 'DblClick');
    end);
end;

procedure TVoynichController.SetTextTo(formname, elementname, value: string);
begin
  PrepareAction(
    Function(): string
    var
      _PropertyHandler: IPropertyHandler;
      _FormHandler: IFormHandler;
    begin
      _PropertyHandler := GlobalContainer.Resolve<IPropertyHandler>
        ('PropertyHandler');
      _FormHandler := GlobalContainer.Resolve<IFormHandler>('FormHandler');
      _PropertyHandler.SetPropertyValue(_FormHandler, formname, elementname, 'AsString', value);
    end);
end;

procedure TVoynichController.GetTextFrom(formname, elementname: string);
begin
  PrepareAction(
    Function(): string
    var
      _PropertyHandler: IPropertyHandler;
      _FormHandler: IFormHandler;
    begin
      _PropertyHandler := GlobalContainer.Resolve<IPropertyHandler>
        ('PropertyHandler');
      _FormHandler := GlobalContainer.Resolve<IFormHandler>('FormHandler');
      _PropertyHandler.GetPropertyValue(_FormHandler, formname, elementname, 'AsString').AsString;
    end);
end;

procedure TVoynichController.WaitUntilElementIsActive(formname, elementname: string);
begin
  PrepareAction(
    Function(): string
    var
      _PropertyHandler: IPropertyHandler;
      _FormHandler: IFormHandler;
      _IsActive: Boolean;
    begin
      _IsActive := False;

      _PropertyHandler := GlobalContainer.Resolve<IPropertyHandler>('PropertyHandler');
      _FormHandler := GlobalContainer.Resolve<IFormHandler>('FormHandler');

      while not _IsActive do
      begin
        _IsActive := _PropertyHandler.GetPropertyValue(_FormHandler, formname, elementname, 'Enabled').AsType<Boolean>;
        Sleep(30000);
      end;

    end);
end;

procedure TVoynichController.WaitUntilElementIsVisible(formname, elementname: string);
begin
  PrepareAction(
    Function(): string
    var
      _PropertyHandler: IPropertyHandler;
      _FormHandler: IFormHandler;
      _IsVisible: Boolean;
    begin
      _IsVisible := False;

      _PropertyHandler := GlobalContainer.Resolve<IPropertyHandler>('PropertyHandler');
      _FormHandler := GlobalContainer.Resolve<IFormHandler>('FormHandler');

      while not _IsVisible do
      begin
        _IsVisible := _PropertyHandler.GetPropertyValue(_FormHandler, formname, elementname, 'Visible').AsType<Boolean>;
        Sleep(30000);
      end;

    end);
end;

procedure TVoynichController.PrepareAction(pFunc: TFunc<string>);
var
  _CommandFactory: TCommandFactory;
  _Command: TCommand;
  _CommandQueue: IQueue<TCommand>;
begin

  _CommandQueue := GlobalContainer.Resolve<IQueue<TCommand>>('CommandQueue');

  _CommandFactory := TCommandFactory.Create;
  _Command := _CommandFactory.SetAnonymousFunction(pFunc).Build;
  _CommandQueue.Enqueue(_Command);
end;

procedure TVoynichController.ExecuteTest;
var
  _CommandQueue: IQueue<TCommand>;
  _Command: TCommand;
begin
  _CommandQueue := GlobalContainer.Resolve<IQueue<TCommand>>('CommandQueue');

  while not _CommandQueue.IsEmpty do
  begin
    _Command := _CommandQueue.Dequeue;
    Context.Response.Content := _Command.AnonymousFunction();
  end;

end;

end.
