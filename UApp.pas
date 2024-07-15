unit UApp;

interface

uses
  Classes, Types, Windows, SysUtils,
  strUtils, ShlObj, TlHelp32, ComObj, ActiveX, Registry, IdTelnet, IdURI,
  Uconfig, Vcl.Dialogs, System.IOUtils;

const
  fileconfig = 'config.ini';

type
  TComInfo = record
    computername, serialdisk, id, ip, mac, user, os: string[255];

  end;



  TApp = class

    app_folder: string;
    api: string;
    mComInfo: TComInfo;
    function getFullInfo: boolean;
    function getserialDisk(disk: string): string;
    function getComname: string;
    function GetIp(const URL: string): string;
    function getUser: String;
    function getmac(ip: string): String;
    function getos: String;
  end;

var
  mApp: TApp;

implementation

function TApp.getFullInfo: boolean;
begin
  try
    app_folder := TDirectory.GetCurrentDirectory;
    api := mconfig.readinifile(app_folder + '\' + fileconfig, 'server', 'api');
    mComInfo.computername := getComname();
    mComInfo.os := getos;
    mComInfo.ip := GetIp(api);
    mComInfo.mac := getmac(mComInfo.ip);
  except
    on e: exception do
  end;

end;

function TApp.getmac(ip: string): string;
const
  wbemFlagForwardOnly = $00000020;
var
  FSWbemLocator: OLEVariant;
  FWMIService: OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject: OLEVariant;
  oEnum: IEnumvariant;
  iValue: LongWord;
  cur_mac, cur_ip, descr: string;
  i: integer;

begin;
  try
    Coinitialize(nil);

    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService := FSWbemLocator.ConnectServer('localhost',
      'root\CIMV2', '', '');
    FWbemObjectSet := FWMIService.ExecQuery
      ('SELECT * FROM Win32_NetworkAdapterConfiguration where IPEnabled=true',
      'WQL', wbemFlagForwardOnly);
    oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;
    while oEnum.Next(1, FWbemObject, iValue) = 0 do
    begin
      try
        descr := String(FWbemObject.Description);
        // if (FWbemObject.MACAddress = nil) then c

        cur_mac := String(FWbemObject.MACAddress);
        cur_mac := StringReplace(cur_mac, ':', '-',
          [rfReplaceAll, rfIgnoreCase]);
        cur_ip := (FWbemObject.ipaddress[0]);
        if ip = cur_ip then
        begin
          result := cur_mac;
          break;
        end;
      except
      end;
    end;
  except
    on e: exception do
  end;
end;

function TApp.GetIp(const URL: string): string;
var
  IdTelnet: TIdTelnet;
  URI: TIdURI; // uses IdURI,IdTelnet;
begin
  try
    IdTelnet := TIdTelnet.Create();
    URI := TIdURI.Create(URL);
    if (URI.port = '') then
      if URI.Protocol = 'http' then
        URI.port := '80'
      else if URI.Protocol = 'https' then
        URI.port := '443'
      else
        URI.port := '443';
    try
      IdTelnet.host := URI.host;
      IdTelnet.port := strtoint(URI.port);
      IdTelnet.ConnectTimeout := 1000;
      IdTelnet.Connect;
      result := IdTelnet.Socket.Binding.ip;
    finally
      IdTelnet.free;
    end;
  except
    result := '';
  end;
end;

function TApp.getComname: string;
var
  CompName: array [0 .. 256] of char;
  i: DWord;
begin
  try
    i := 256;
    GetComputerName(CompName, i);
    result := StrPas(CompName);
  except

  end;
end;

function TApp.getserialDisk(disk: string): string;
var
  VolumeName, FileSystemName: array [0 .. MAX_PATH - 1] of char;
  VolumeSerialNo: DWord;
  MaxComponentLength, FileSystemFlags: Cardinal;
begin
  try
    GetVolumeInformation(PChar(disk + '\'), VolumeName, MAX_PATH,
      @VolumeSerialNo, MaxComponentLength, FileSystemFlags, FileSystemName,
      MAX_PATH);
    result := inttostr(VolumeSerialNo);
  except
    result := '';
  end;
end;

function TApp.getUser: String;
var
  nSize: DWord;
begin
  try
    nSize := 1024;
    SetLength(result, nSize);
    if getUserName(PChar(result), nSize) then
      SetLength(result, nSize - 1);
  except
  end;
end;

function TApp.getos(): string;
var
  // info: TOSVersionInfoW;
  info: TOSVersion;
  verOS: string;
begin
  try
    result := 'Windows XP';
    result := TOSVersion.ToString;
  except

  end;
end;

end.
