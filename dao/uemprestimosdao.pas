unit uEmprestimosDAO;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Controls, Graphics, Dialogs, ZDataSet, uModuloDados, uEmprestimo, Generics.Collections, ZConnection;

type
  TListaEmprestimos = TObjectList<TEmprestimo>;

  TEmprestimosDAO = class
  private
    FConnection: TZConnection;
  public
    function VerificarLivro(LivroID : Integer) : Boolean;
    procedure Inserir(Emprestimo : TEmprestimo);
    function CarregarEmprestimos: TListaEmprestimos;
    constructor Create(AConnection: TZConnection);
    procedure ListarEmprestimosParaDataset(AQuery: TZQuery);
    procedure ListarEmprestimosPorId(AQuery: TZQuery; Id : Integer);
  end;

implementation

constructor TEmprestimosDAO.Create(AConnection: TZConnection);
begin
  FConnection := AConnection;
end;

procedure TEmprestimosDAO.ListarEmprestimosParaDataset(AQuery: TZQuery);
begin
  AQuery.Connection := GetConnection;
  AQuery.Close;
  AQuery.SQL.Clear;

  AQuery.SQL.Add('SELECT EMPRESTIMOS.ID, USUARIOS.NOME AS USUARIO, LIVROS.TITULO AS LIVRO, EMPRESTIMOS.DATA_EMPRESTIMO, EMPRESTIMOS.DATA_DEVOLUCAO');
  AQuery.SQL.Add('FROM EMPRESTIMOS');
  AQuery.SQL.Add('INNER JOIN USUARIOS ON USUARIOS.ID = EMPRESTIMOS.USUARIO_ID');
  AQuery.SQL.Add('INNER JOIN LIVROS ON LIVROS.ID = EMPRESTIMOS.LIVRO_ID');
  AQuery.SQL.Add('ORDER BY EMPRESTIMOS.DATA_EMPRESTIMO DESC');

  AQuery.Open;
end;

procedure TEmprestimosDAO.ListarEmprestimosPorId(AQuery: TZQuery; ID : Integer);
begin
  AQuery.Connection := GetConnection;
  AQuery.Close;
  AQuery.SQL.Clear;

  AQuery.SQL.Add('SELECT EMPRESTIMOS.ID, USUARIOS.NOME AS USUARIO, LIVROS.TITULO AS LIVRO, EMPRESTIMOS.DATA_EMPRESTIMO, EMPRESTIMOS.DATA_DEVOLUCAO');

  AQuery.SQL.Add('FROM EMPRESTIMOS');

  AQuery.SQL.Add('INNER JOIN USUARIOS ON USUARIOS.ID = EMPRESTIMOS.USUARIO_ID');
  AQuery.SQL.Add('INNER JOIN LIVROS ON LIVROS.ID = EMPRESTIMOS.LIVRO_ID');

  if ID > 0 then
  begin
    AQuery.SQL.Add('WHERE EMPRESTIMOS.USUARIO_ID = :USUARIO_ID');
  end;

  AQuery.SQL.Add('ORDER BY EMPRESTIMOS.DATA_EMPRESTIMO DESC');

  if ID > 0 then
    AQuery.ParamByName('USUARIO_ID').AsInteger := ID;

  AQuery.Open;
end;

function TEmprestimosDAO.VerificarLivro(LivroID : Integer) : Boolean;
var
Query: TZQuery;
begin
 Query := TZQuery.Create(nil);
 try
Query.Connection := GetConnection;
    Query.SQL.Add('SELECT * FROM LIVROS WHERE ID = :ID');
    Query.ParamByName('ID').AsInteger := LivroID;
    Query.Open;

    if not QUERY.IsEmpty then
    begin
    Result := True;
    end
    else
    Result := False
 finally
  Query.Free;
 end;


end;

procedure TEmprestimosDAO.Inserir(Emprestimo : TEmprestimo);
 var
  Query: TZQuery;
begin
  Query := TZQuery.Create(nil);
  try
    Query.Connection := GetConnection;

    Query.SQL.Add('INSERT INTO EMPRESTIMOS (USUARIO_ID, LIVRO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO)');
    Query.SQL.Add('VALUES (:USUARIO_ID, :LIVRO_ID, :DATA_EMPRESTIMO, :DATA_DEVOLUCAO)');

    Query.ParamByName('USUARIO_ID').AsInteger := Emprestimo.UsuarioId;
    Query.ParamByName('LIVRO_ID').AsInteger := Emprestimo.LivroId;
    Query.ParamByName('DATA_EMPRESTIMO').AsDateTime := Emprestimo.DataEmprestimo;

    if Emprestimo.DataDevolucao > 0 then
      Query.ParamByName('DATA_DEVOLUCAO').AsDateTime := Emprestimo.DataDevolucao
    else
      Query.ParamByName('DATA_DEVOLUCAO').Clear;

    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

function TEmprestimosDAO.CarregarEmprestimos: TListaEmprestimos;
var
  Query: TZQuery;
  Emprestimo: TEmprestimo;
begin
  Query := TZQuery.Create(nil);
  Result := TListaEmprestimos.Create(True);
  try
    Query.Connection := GetConnection;
    Query.SQL.Add('SELECT * FROM EMPRESTIMOS');
    Query.Open;

    while not Query.EOF do
    begin
      Emprestimo := TEmprestimo.Create(
        Query.FieldByName('ID').AsInteger,
        Query.FieldByName('USUARIO_ID').AsInteger,
        Query.FieldByName('LIVRO_ID').AsInteger,
        Query.FieldByName('DATA_EMPRESTIMO').AsDateTime,
        Query.FieldByName('DATA_DEVOLUCAO').AsDateTime
      );

      Result.Add(Emprestimo);

      Query.Next;
    end;

  finally
    Query.Free;
  end;
end;

end.

