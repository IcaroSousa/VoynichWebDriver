unit UFormHandlerInterface;

interface

Uses vcl.Forms,
  System.Classes,
  System.Rtti;

Type

  IFormHandler = Interface
    ['{FC29C471-910B-4CC5-BF82-2709E33A43C6}']

    Procedure Initialize(pFormName: string);
    Procedure Finalize(pFormName: string);

    Function GetActiveForm: TForm;
    Function FindRttiTypeForm(pFormName: string): TRttiType;
    Function FindComponentInstanceInForm(pFormName, pComponentName: string): TComponent;
  End;

implementation

end.
