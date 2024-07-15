program Monitor;

uses
  Vcl.Forms,
  Umain in 'Umain.pas' {Form1} ,
  Unetwork in 'Unetwork.pas',
  UMonFile in 'UMonFile.pas',
  Ulog in 'Ulog.pas',
  UUSB in 'UUSB.pas',
  UApp in 'UApp.pas',
  UConfig in 'UConfig.pas', Winapi.Windows;

{$R *.res}

var
  Mutex: THandle;

begin
  Mutex := CreateMutex(nil, True, 'Monitor');
  if (Mutex = 0) OR (GetLastError = ERROR_ALREADY_EXISTS) then
    exit();
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Form1.Visible := False;
  Application.Run;

end.
