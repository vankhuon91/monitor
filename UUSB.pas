unit UUSB;

interface

uses  Unetwork, UApp, System.SysUtils, System.JSON;

type
  TUSB = class
    function addusb(disk: string): string;
    function removeusb(disk: string): string;
    function eventCreateFile(filename:string):string;

  end;

var
  mUSB: TUSB;

implementation

{ TUSB }
uses Umonfile;
function TUSB.addusb(disk: string): string;
var
  data: string;
begin
  try

    mMonFile.MonitorDisk(disk);
    data := Format
      ('[{"computer_name":%s,"local_ip": %s,"mac": %s,"event_type": "usb","event_info": %s,"event_time":"%s"}]',
      [TJSONSTRING.Create(mApp.mComInfo.computername).ToString,
      TJSONSTRING.Create(mApp.mComInfo.ip).ToString,
      TJSONSTRING.Create(mApp.mComInfo.mac).ToString,
       TJSONSTRING.Create('Plug-in ' + disk).ToString ,
      FormatDateTime('yyyy-mm-dd hh:nn:ss', now())]);
    mhttp.sendata(mApp.api + '/api/v1/events/insert', 'POST', data);
  except

  end;
end;

function TUSB.eventCreateFile(filename: string): string;
var
  data: string;
begin
  try

    data := Format
      ('[{"computer_name":%s,"local_ip": %s,"mac": %s,"event_type": "usb","event_info": %s,"event_time":"%s"}]',
      [TJSONSTRING.Create(mApp.mComInfo.computername).ToString,
      TJSONSTRING.Create(mApp.mComInfo.ip).ToString,
      TJSONSTRING.Create(mApp.mComInfo.mac).ToString,
       TJSONSTRING.Create('Create File ' + filename).ToString ,
      FormatDateTime('yyyy-mm-dd hh:nn:ss', now())]);
    mhttp.sendata(mApp.api + '/api/v1/events/insert', 'POST', data);
  except

  end;
end;

function TUSB.removeusb(disk: string): string;
var
  data: string;
begin
  try

    data := Format
      ('[{"computer_name":%s,"local_ip": %s,"mac": %s,"event_type": "usb","event_info": %s,"event_time":"%s"}]',
      [TJSONSTRING.Create(mApp.mComInfo.computername).ToString,
      TJSONSTRING.Create(mApp.mComInfo.ip).ToString,
      TJSONSTRING.Create(mApp.mComInfo.mac).ToString,
       TJSONSTRING.Create('Plug-out ' + disk).ToString ,
      FormatDateTime('yyyy-mm-dd hh:nn:ss', now())]);
    mhttp.sendata(mApp.api + '/api/v1/events/insert', 'POST', data);
  except

  end;
end;


end.
