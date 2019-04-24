unit UTakeScreenshot;

interface

Uses
  UTakeScreenshotInterface,
  Winapi.WIndows,
  System.SysUtils,
  Vcl.Graphics;

Type
  TTakeScreenshot = class(TInterfacedObject, ITakeScreenshot)
  private
    Function PrepareFilePath(pFileName: string; pWorkDir: string = String.Empty): String;
    procedure SaveScreenshotToFile(pScreenHandle: HDC; pWindowPosition: TRect; pFilePath: String);

  public
    Procedure GetScreenshot(pFileName: string; pFullScreen: Boolean = True);
  end;

implementation

{ TTakeScreenshot }

procedure TTakeScreenshot.GetScreenshot(pFileName: string; pFullScreen: Boolean = True);
var
  _WindowHandle: HWND;
  _ScreenHandle: HDC;
  _WindowPosition: TRect;
  _FilePath: String;
begin

  Try

    _WindowHandle := GetForegroundWindow;

    if pFullScreen then
    begin
      GetWindowRect(_WindowHandle, _WindowPosition);
      _ScreenHandle := GetWindowDC(_WindowHandle);
    end
    else
    begin
      GetClientRect(_WindowHandle, _WindowPosition);
      _ScreenHandle := GetDC(_WindowHandle);
    end;

    _FilePath := PrepareFilePath(pFileName);
    SaveScreenshotToFile(_ScreenHandle, _WindowPosition, _FilePath);

  Finally
    ReleaseDC(_WindowHandle, _ScreenHandle);
  End;

end;

function TTakeScreenshot.PrepareFilePath(pFileName, pWorkDir: string): String;
begin

  if pWorkDir = String.Empty then
    pWorkDir := GetCurrentDir;

  pWorkDir := Format('%s%s%s', [pWorkDir, PathDelim, 'Screenshots']);
  if not DirectoryExists(pWorkDir) then
    CreateDir(pWorkDir);

  Result := Format('%s%s%s_%s.bmp', [pWorkDir, PathDelim, pFileName,
    FormatDateTime('mm-dd-yyyy-hhnnss', Now())]);

end;

procedure TTakeScreenshot.SaveScreenshotToFile(pScreenHandle: HDC; pWindowPosition: TRect; pFilePath: String);
var
  _Bitmap: Vcl.Graphics.TBitmap;
  _Height, _Width: Integer;
begin

  try
    try

      _Height := (pWindowPosition.Bottom - pWindowPosition.Top);
      _Width := (pWindowPosition.Right - pWindowPosition.Left);

      _Bitmap := Vcl.Graphics.TBitmap.Create;
      _Bitmap.Height := _Height;
      _Bitmap.Width := _Width;

      BitBlt(_Bitmap.Canvas.Handle, 0, 0, _Width, _Height, pScreenHandle, 0, 0, SRCCOPY);

      _Bitmap.SaveToFile(pFilePath);
    except
      raise Exception.Create(Format('Falha ao preparar Screenshot -> %s', [pFilePath]));
    end;
  finally
    FreeAndNil(_Bitmap);
  end;

end;

end.
