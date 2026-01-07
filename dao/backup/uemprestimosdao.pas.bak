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
  end;

implementation

constructor TEmprestimosDAO.Create(AConnection: TZConnection);
begin
  FConnection := AConnection;
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

