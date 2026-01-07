unit config;

{$mode ObjFPC}{$H+}

interface

uses
  Horse.JWT, horse.CORS;

procedure ConfigurarHorseJWT();
procedure ConfigurarHorseCORS();

var
  publicRoutes : array of string;
  configJWT : IHorseJWTConfig;

const
  JWT_KEY = '1234567';

implementation

procedure ConfigurarHorseJWT();
begin
  SetLength(publicRoutes, 1);
  publicRoutes[0] := '/api/login';

  configJWT := THorseJWTConfig.New.SkipRoutes(publicRoutes);
end;

procedure ConfigurarHorseCORS();
begin
  HorseCORS
    .AllowedOrigin('*')
    .AllowedHeaders('Content-Type, Accept, Accept-Encoding, X-Requested-With, Content-Length, Authorization, x-user, x-password, x-filename, x-id, x-emp, bearer, Bearer')
    .AllowedMethods('PUT, GET, POST, DELETE, OPTIONS, PATCH')
    .ExposedHeaders('*')
    .AllowedCredentials(True);
end;

end.
