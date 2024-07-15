unit Ulog;

interface

uses System.SysUtils;

const
  FileLog = 'Monitor.log';

type
  Tlog = class
    function savelog(data: string; isrewrite: boolean): boolean;
    function savedata(filename, data: string; isrewrite: boolean): boolean;
  end;

var
  mLog: Tlog;

implementation

{ Tlog }

function Tlog.savelog(data: string; isrewrite: boolean): boolean;
var
  f: textfile;
  today: string;
begin
  try

    assignfile(f, FileLog);
    if not fileexists(FileLog) or isrewrite then
      rewrite(f)
    else
      append(f);
    today := FormatDateTime('yy-mm-dd hh:nn:ss', now());
    Writeln(f, today + '--' + data);
    closefile(f);

  except

  end;

end;

function Tlog.savedata(filename, data: string; isrewrite: boolean): boolean;
var
  f: textfile;
  today: string;
begin
  try

    assignfile(f, filename);
    if not fileexists(filename) or isrewrite then
      rewrite(f)
    else
      append(f);
    today := FormatDateTime('yy-mm-dd hh:nn:ss', now());
    Writeln(f, today + '--' + data);
    closefile(f);

  except

  end;

end;

end.
