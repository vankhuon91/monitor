﻿unit UMonFile;

interface

uses Windows, WinSvc, cbfconstants, StrUtils,
  cbfcbmonitor, SysUtils, classes, TlHelp32, Dialogs, Json, Ulog,UUSB;

const
  NumExt = 6;
  MonExt: array [1 .. NumExt] of string = ('.exe', '.dll', '.bat', '.docx',
    '.pdf', '.txt');

type

  TMonFile = class
    cbfMonitor: TcbfCBMonitor;

    constructor Create();
    function MonitorDisk(Disk: String): boolean;

    procedure cbfFilterNotifyCreateFile(Sender: TObject; const filename: String;
      DesiredAccess: integer; FileAttributes: integer; ShareMode: integer;
      Options: integer; CreateDisposition: integer; Status: integer;
      var ResultCode: integer);
  end;

var
  mMonFile: TMonFile;

implementation

const
  FGuid = '{713CC6CE-B3E2-4fd9-838D-E28F558F6866}';
  ALTITUDE_FAKE_VALUE_FOR_DEBUG = 360000;
  NumlistFile = 1000;

constructor TMonFile.Create;
var
  pathexe: string;

begin
  try
    inherited Create();
    cbfMonitor := TcbfCBMonitor.Create(nil);
    cbfMonitor.Initialize(FGuid);
    // cbfMonitor.OnNotifyWriteFile := FilterNotifyWriteFile;
    cbfMonitor.OnNotifyCreateFile := cbfFilterNotifyCreateFile;
    // cbfMonitor.OnNotifySetFileAttributes := cbfFilterNotifySetFileAttributes;
  except

  end;
end;

function TMonFile.MonitorDisk(Disk: string): boolean;
var
  MyStr: PChar;
  i, Length: integer;
const
  Size: integer = 200;
begin
  try
    mlog.savelog('monitor usb ' + Disk + ' ' + inttostr(Disk.Length), false);
    for i := 1 to NumExt do

      cbfMonitor.AddFilterRule(Disk + '*' + MonExt[i],
        cbfconstants.FS_NE_CREATE_HARD_LINK or cbfconstants.FS_NE_CREATE);
    if not cbfMonitor.Active then
    begin
      cbfMonitor.ProcessCachedIORequests := true;
      cbfMonitor.StartFilter();
    end;

  except
    on e: exception do
      mlog.savelog('err set mon disk' + e.Message, false);
  end;
end;

procedure TMonFile.cbfFilterNotifyCreateFile(Sender: TObject;
  const filename: String; DesiredAccess: integer; FileAttributes: integer;
  ShareMode: integer; Options: integer; CreateDisposition: integer;
  Status: integer; var ResultCode: integer);
var
  process, name: string;
begin
  try
    mlog.savelog('create file ' + filename, false);
    musb.eventCreateFile(filename);
  except

  end;
end;

end.
