unit uLivroDAO;

{$mode Delphi}

interface

uses
  Classes, SysUtils, ZDataset, uModuloDados, uLivro, ZConnection, Generics.Collections;

type
  TListaLivros = TObjectList<TLivro>;

  TLivroDAO = class
  private
    FConnection: TZConnection;
  public
    constructor Create(AConnection: TZConnection);
    procedure Inserir(Livro: TLivro);
    function ProcurarPorId(ID: Integer): TLivro;
    procedure Deletar(ID: Integer);
    procedure Atualizar(Livro: TLivro);
    function CarregarLivros : TListaLivros;
    function VerificarAutor(AutorID : Integer) : Boolean;
    procedure ListarLivrosParaDataset(aQuery: TZQuery);
    procedure ListarLivrosPorTitulo(AQuery: TZQuery; Filtro: String);
  end;

implementation

constructor TLivroDAO.Create(AConnection: TZConnection);
begin
  FConnection := AConnection;
end;

procedure TLivroDAO.Inserir(Livro: TLivro);
var
  Query: TZQuery;
begin
  Query := TZQuery.Create(nil);
  try
    Query.Connection := GetConnection;

    Query.SQL.Add('INSERT INTO LIVROS (TITULO, AUTOR_ID, ANO_PUBLICACAO, ISBN)');
    Query.SQL.Add('VALUES (:TITULO, :AUTOR_ID, :ANO_PUBLICACAO, :ISBN)');

    Query.ParamByName('TITULO').AsString := Livro.Titulo;
    Query.ParamByName('AUTOR_ID').AsInteger := Livro.AutorID;
    Query.ParamByName('ANO_PUBLICACAO').AsInteger := Livro.Ano;
    Query.ParamByName('ISBN').AsString := Livro.ISBN;

    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TLivroDAO.Atualizar(Livro: TLivro);
var
Query: TZQuery;
begin
 Query := TZQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Add('UPDATE LIVROS SET TITULO = :TITULO, AUTOR_ID = :AUTOR_ID, ANO_PUBLICACAO = :ANO_PUBLICACAO, ISBN = :ISBN WHERE ID = :ID');
    Query.ParamByName('TITULO').AsString := Livro.Titulo;
    Query.ParamByName('AUTOR_ID').AsInteger := Livro.AutorID;
    Query.ParamByName('ANO_PUBLICACAO').AsInteger := Livro.Ano;
    Query.ParamByName('ISBN').AsString := Livro.ISBN;
    Query.ParamByName('ID').AsInteger := Livro.ID;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TLivroDAO.Deletar(ID: Integer);
 var
Query: TZQuery;
begin
 Query := TZQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Add('DELETE FROM LIVROS WHERE ID = :ID');
    Query.ParamByName('ID').AsInteger := ID;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

function TLivroDAO.ProcurarPorId(ID: Integer): TLivro;
var
Query: TZQuery;
begin
 Result:= nil;
 Query := TZQuery.Create(nil);
  try
    Query.Connection := GetConnection;
    Query.SQL.Add('SELECT * FROM LIVROS WHERE ID = :ID');
    Query.ParamByName('ID').AsInteger := ID;
    Query.Open;

    if not Query.IsEmpty then
    begin

    Result :=  TLivro.Create(
    ID,
    Query.FieldByName('ANO_PUBLICACAO').AsInteger,
    Query.FieldByName('AUTOR_ID').AsInteger,
    Query.FieldByName('TITULO').AsString,
    Query.FieldByName('ISBN').AsString
      );


    end;
  finally
    Query.Free;
  end;
end;

function TLivroDAO.VerificarAutor(AutorID : Integer) : Boolean;
var
Query: TZQuery;
begin
 Query := TZQuery.Create(nil);
 try
Query.Connection := GetConnection;
    Query.SQL.Add('SELECT * FROM AUTORES WHERE ID = :ID');
    Query.ParamByName('ID').AsInteger := AutorID;
    Query.Open;

    if not QUERY.IsEmpty then
    begin
    Result := True;
    end
    else
    Result := False;

 finally
  Query.Free;
 end;


end;

function TLivroDAO.CarregarLivros : TListaLivros;
var
  Query: TZQuery;
  Livro: TLivro;
begin
  Query := TZQuery.Create(nil);
  Result := TListaLivros.Create(True);
  try
    Query.Connection := GetConnection;
    Query.SQL.Add('SELECT L.*, A.NOME AS AUTOR_NOME');
    Query.SQL.Add('FROM LIVROS L');
    Query.SQL.Add('INNER JOIN AUTORES A ON A.ID = L.AUTOR_ID');

    Query.Open;

    while not Query.EOF do
    begin
      Livro := TLivro.Create(
        Query.FieldByName('ID').AsInteger,
        Query.FieldByName('ANO_PUBLICACAO').AsInteger,
        Query.FieldByName('AUTOR_ID').AsInteger,
        Query.FieldByName('TITULO').AsString,
        Query.FieldByName('ISBN').AsString
      );

      Livro.AutorNome := Query.FieldByName('AUTOR_NOME').AsString;

      Result.Add(Livro);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

procedure TLivroDAO.ListarLivrosParaDataset(AQuery: TZQuery);
begin
  AQuery.Connection := GetConnection;

  AQuery.Close;
  AQuery.SQL.Clear;

  AQuery.SQL.Add('SELECT L.ID, L.TITULO, A.NOME AS AUTOR, L.ANO_PUBLICACAO, L.ISBN');
  AQuery.SQL.Add('FROM LIVROS L');
  AQuery.SQL.Add('LEFT JOIN AUTORES A ON A.ID = L.AUTOR_ID');

  AQuery.Open;

end;

procedure TLivroDAO.ListarLivrosPorTitulo(AQuery: TZQuery; Filtro: String);
begin
  AQuery.Connection := GetConnection;

  AQuery.Close;
  AQuery.SQL.Clear;

  AQuery.SQL.Add('SELECT L.ID, L.TITULO, A.NOME AS AUTOR, L.ANO_PUBLICACAO, L.ISBN');
  AQuery.SQL.Add('FROM LIVROS L');
  AQuery.SQL.Add('LEFT JOIN AUTORES A ON A.ID = L.AUTOR_ID');

  if Trim(Filtro) <> '' then
  begin
    AQuery.SQL.Add('WHERE LOWER(L.TITULO) LIKE LOWER(:TITULO)');
  end;

  AQuery.SQL.Add('ORDER BY L.TITULO');

  if Trim(Filtro) <> '' then
    AQuery.ParamByName('TITULO').AsString := '%' + Filtro + '%';

  AQuery.Open;
end;


end.
