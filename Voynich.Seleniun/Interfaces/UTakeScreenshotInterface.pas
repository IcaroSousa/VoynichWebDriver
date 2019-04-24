unit UTakeScreenshotInterface;

interface
  Type

    ITakeScreenshot = interface
      ['{F1F4F978-EDAA-420F-B301-A0A10D1F3967}']
      Procedure GetScreenshot(pFileName: string; pFullScreen: Boolean = True);
    end;

implementation

end.
