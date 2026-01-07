unit uUsuarioDAO;

{$mode Delphi}

interface

uses
  SysUtils, ZDataset, uModuloDados;

type
  TUsuarioDAO = class
  public
    function BuscarPorEmail(AEmail: String): TZQuery;
  end;

implementation

function TUsuarioDAO.BuscarPorEmail(AEmail: String): TZQuery;
var
  Qry: TZQuery;
begin
  Qry := TZQuery.Create(nil);
  Qry.Connection := GetConnection;
  Qry.SQL.Add('SELECT ID, USUARIO, SENHA, NOME FROM USUARIOS WHERE USUARIO = :EMAIL');
  Qry.ParamByName('EMAIL').AsString := AEmail;
  Qry.Open;
  Result := Qry;
end;

end.
