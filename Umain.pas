unit Umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SHChangeNotify, Vcl.StdCtrls, UmonFile,
  Ulog, Unetwork, Uconfig, Uapp,Uusb, MRVAudioOutput, MRVAudioPlayer;

type
  TForm1 = class(TForm)
    SHChangeNotify1: TSHChangeNotify;
    procedure SHChangeNotify1DriveAdd(Sender: TObject; Flags: Cardinal;
      Path1: string);
    procedure FormCreate(Sender: TObject);
    procedure SHChangeNotify1DriveRemoved(Sender: TObject; Flags: Cardinal;
      Path1: string);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var path:string;

begin
     path:= '\\?\Volume{00000001-0000-0000-0000-30c300000000}\';
     mlog.savedata(path+'abc.txt','new',false)
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  try

    mMonFile := TMonFile.Create;
    mLog := Tlog.Create;
    mhttp := Thttp.Create;
    mConfig := Tconfig.Create;
    mApp := TApp.Create;
    mUSB:=Tusb.Create;


    SHChangeNotify1.Execute;
    mApp.getFullInfo;
    mLog.savelog('create form', true);
  except
    on e: exception do
      mLog.savelog('Error:' + e.Message, false)

  end;
end;

procedure TForm1.SHChangeNotify1DriveAdd(Sender: TObject; Flags: Cardinal;
  Path1: string);
begin

  try
    musb.addusb(Path1);
  except
    on e: exception do
      mLog.savelog('Error:' + e.Message, false)

  end;
end;

procedure TForm1.SHChangeNotify1DriveRemoved(Sender: TObject; Flags: Cardinal;
  Path1: string);
begin
  try
    musb.removeusb(Path1);
  except
    on e: exception do
      mLog.savelog('Error:' + e.Message, false)

  end;
end;

end.
