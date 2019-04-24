unit UActionHandlerInterface;

interface

Uses UFormHandlerInterface,
  Spring.Collections,
  System.Rtti;

Type

  IActionHandler = Interface
    ['{9FB7AE26-D2E5-4E74-AA2F-BACE10D7EDD8}']
    Procedure Perform(pFormHandler: IFormHandler; pFormName, pElementName, pActionName: string; pParams: TArray<TValue> = nil);
  End;

implementation

end.
