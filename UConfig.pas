unit UConfig;

interface

uses
  System.IniFiles, System.SysUtils;

type
	TConfig = class
		procedure saveinifile(FileName, section, key, value: string);
		function readinifile(FileName, section, key: string): string;
	end;

var	
	mConfig: TConfig;

implementation

{ TConfig }

function TConfig.readinifile(FileName, section, key: string): string;
var
	fileini: TInifile;
begin
	try
		fileini := TInifile.Create(FileName);
		result := fileini.ReadString(section, key, '');

	except

	end;
end;

procedure TConfig.saveinifile(FileName, section, key, value: string);
var
	fileini: TInifile;
begin
	try
		fileini := TInifile.Create(FileName);
		fileini.WriteString(section, key, value);
		fileini.UpdateFile();
		fileini.Free;
	except

	end;
end;

end.
