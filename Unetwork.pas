unit Unetwork;

interface

uses System.StrUtils, System.SysUtils, REST.CLIENT, REST.Types,
  System.Net.HttpClientcomponent,
  System.Net.HttpClient, Ulog;

type
  Thttp = class
    function sendata(host, method, body: string): string;
  end;

var
  mhttp: Thttp;

implementation

function Thttp.sendata(host, method, body: string): string;
var
  RestClient: Trestclient;
  restrequest: Trestrequest;
  restResponse: Trestresponse;

begin
  try
    try
      RestClient := Trestclient.Create(nil);
      restrequest := Trestrequest.Create(nil);
      restResponse := Trestresponse.Create(nil);

      RestClient.BaseURL := host;
      RestClient.Accept := 'application/json';
      RestClient.AcceptCharset := 'UTF-8';
      RestClient.ContentType := 'application/json';
      RestClient.SecureProtocols := [THTTPSecureProtocol.TLS1,
        THTTPSecureProtocol.TLS11, THTTPSecureProtocol.TLS12];

      restrequest.CLIENT := RestClient;
      case IndexStr(method, ['GET', 'POST', 'PUT', 'DELETE']) of
        0:
          restrequest.method := Trestrequestmethod.rmGET;
        1:
          restrequest.method := Trestrequestmethod.rmPOST;
        2:
          restrequest.method := Trestrequestmethod.rmPUT;
        3:
          restrequest.method := Trestrequestmethod.rmDELETE;
      end;

      restrequest.ClearBody;
      restrequest.AddBody(body, ctapplication_json);
      restrequest.Response := restResponse;
      restrequest.Execute;
      result := restResponse.Content;
    finally
      RestClient.Free;
      restrequest.Free;
      restResponse.Free;

    end;

  except
    on e: exception do
      mlog.savelog('Error send data ' + host + ' ' + body + ' --.' +
        e.Message, false)

  end;
end;

end.
