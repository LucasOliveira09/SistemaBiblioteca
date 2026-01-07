program api;

{$mode delphi}{$H+}

uses
  SysUtils, Horse, Horse.CORS, Horse.Jhonson, Horse.Compression, Horse.JWT,
  zcomponent, uLivrosController, controller.auth, uModuloDados,
  uEmprestimoService, config;

procedure Listen(_listen : THorse);
begin
  WriteLn('Servidor ativo na porta: '+ IntToStr(_listen.Port));
end;

const
  JWT_KEY = '1234567';
var
  App : THorse;
begin
  try
    GetConnection.Connect;
  except
    on E: Exception do
    begin
      WriteLn('Erro ao conectar no banco: ' + E.Message);
      ReadLn;
      Exit;
    end;
  end;

  App := THorse.Create;
  ConfigurarHorseCORS();
  ConfigurarHorseJWT();

  App.Use(CORS);
  App.Use(Compression);
  App.Use(Jhonson);
  App.Use(HorseJWT(JWT_KEY, configJWT));

  controller.auth.Registry(App);
  uLivrosController.Registry(App);

  THorse.Listen(9000, @Listen);
end.

