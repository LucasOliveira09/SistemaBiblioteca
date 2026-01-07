unit uAutoresDAO;

{$mode Delphi}

interface

uses
  Classes, SysUtils, ZDataset, ZConnection, uAutor, uModuloDados;

type
  TAutoresDAO = class
  private
    FConnection: TZConnection;
  public
    constructor Create(AConnection: TZConnection);

    procedure Inserir(Autor: TAutor);
    procedure Atualizar(Autor: TAutor);
    procedure Deletar(ID: Integer);

    procedure ListarAutoresParaDataset(AQuery: TZQuery);
    procedure FiltrarAutoresPorNome(AQuery: TZQuery; Filtro: String);
  end;

implementation

constructor TAutoresDAO.Create(AConnection: TZConnection);
begin
  FConnection := AConnection;
end;

procedure TAutoresDAO.Inserir(Autor: TAutor);
var
  Query: TZQuery;
begin
  Query := TZQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Add('INSERT INTO AUTORES (NOME, NACIONALIDADE) VALUES (:NOME, :NACIONALIDADE)');
    Query.ParamByName('NOME').AsString := Autor.Nome;
    Query.ParamByName('NACIONALIDADE').AsString := Autor.Nacionalidade;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TAutoresDAO.Atualizar(Autor: TAutor);
var
  Query: TZQuery;
begin
  Query := TZQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Add('UPDATE AUTORES SET NOME = :NOME, NACIONALIDADE = :NACIONALIDADE WHERE ID = :ID');
    Query.ParamByName('NOME').AsString := Autor.Nome;
    Query.ParamByName('NACIONALIDADE').AsString := Autor.Nacionalidade;
    Query.ParamByName('ID').AsInteger := Autor.ID;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TAutoresDAO.Deletar(ID: Integer);
var
  Query: TZQuery;
begin
  Query := TZQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Add('DELETE FROM AUTORES WHERE ID = :ID');
    Query.ParamByName('ID').AsInteger := ID;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TAutoresDAO.ListarAutoresParaDataset(AQuery: TZQuery);
begin
  AQuery.Connection := GetConnection;
  AQuery.Close;
  AQuery.SQL.Clear;
  AQuery.SQL.Add('SELECT * FROM AUTORES ORDER BY NOME');
  AQuery.Open;
end;

procedure TAutoresDAO.FiltrarAutoresPorNome(AQuery: TZQuery; Filtro: String);
begin
  AQuery.Connection := GetConnection;
  AQuery.Close;
  AQuery.SQL.Clear;
  AQuery.SQL.Add('SELECT * FROM AUTORES');

  if Trim(Filtro) <> '' then
    AQuery.SQL.Add('WHERE LOWER(NOME) LIKE LOWER(:NOME)');

  AQuery.SQL.Add('ORDER BY NOME');

  if Trim(Filtro) <> '' then
    AQuery.ParamByName('NOME').AsString := '%' + Filtro + '%';

  AQuery.Open;
end;

end.
