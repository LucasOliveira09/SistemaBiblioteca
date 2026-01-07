unit uLivroService;

{$mode objfpc}{$H+}

interface

uses
  Classes, Interfaces, SysUtils, Controls, Graphics, Dialogs, uLivroDAO, uLivro, ZConnection, fpjson, jsonparser, ZDataset;

type
  TLivroService = class
  private
    FDAO: TLivroDAO;
  public
    constructor Create(Connection: TZConnection);
    destructor Destroy; override;

    procedure CriarLivro(Titulo, ISBN: String; AutorID, Ano: Integer);
    procedure AtualizarLivro(Livro: TLivro);
    function BuscarPorID(Id: Integer): TLivro;
    function ValidarDados(Titulo, ISBN: String; AutorID: Integer): Boolean;
    procedure Deletar(Id: Integer);
    function LimparTexto(Texto: String): String;
    function CarregarLivros : TJSONArray;
    procedure FiltrarLivros(AQuery: TZQuery; Filtro: String);

  end;

implementation

constructor TLivroService.Create(Connection: TZConnection);
begin
  FDAO := TLivroDAO.Create(Connection);
end;

destructor TLivroService.Destroy;
begin
  FDAO.Free;
  inherited;
end;

function TLivroService.LimparTexto(Texto: String): String;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Texto) do
  begin
    if Texto[i] in ['0'..'9'] then
      Result := Result + Texto[i];
  end
end;

function TLivroService.ValidarDados(Titulo, ISBN: String; AutorID: Integer): Boolean;
var
 ISBNlimpo : String;
begin

  ISBNlimpo := LimparTexto(ISBN);
  Result := (Length(Trim(Titulo)) >= 3) and
            (Length(ISBNlimpo) = 13) and
            (FDAO.VerificarAutor(AutorID));
end;

procedure TLivroService.CriarLivro(Titulo, ISBN: String; AutorID, Ano: Integer);
var
  Livro: TLivro;
begin
  if not ValidarDados(Titulo, ISBN, AutorID) then
    raise Exception.Create('Dados inválidos para inserção. Verifique nome, e-mail e telefone.');

  Livro := TLivro.Create(0, Ano, AutorID, Titulo, ISBN);
  try
    FDAO.Inserir(Livro);
  finally
     Livro.Free;
  end;
end;

procedure TLivroService.AtualizarLivro(Livro: TLivro);
begin
  if not ValidarDados(Livro.Titulo, Livro.ISBN, Livro.AutorID) then
    raise Exception.Create('Dados inválidos para atualização.');

  FDAO.Atualizar(Livro);
end;

function TLivroService.BuscarPorID(Id: Integer): TLivro;
begin
  if Id <= 0 then
    raise Exception.Create('ID inválido para busca!');

    Result := FDAO.ProcurarPorId(Id);
end;

procedure TLivroService.FiltrarLivros(AQuery: TZQuery; Filtro: String);
begin
  Filtro := Trim(Filtro);

  FDAO.ListarLivrosPorTitulo(AQuery, Filtro);
end;

procedure TLivroService.Deletar(Id: Integer);
begin
  if Id <= 0 then
    raise Exception.Create('ID inválido para deletar!');

    FDAO.Deletar(Id);
end;

function TLivroService.CarregarLivros : TJSONArray;
var
  Lista : TListaLivros;
  JSONArray : TJSONArray;
  JSONObject : TJSONObject;
  Livro : TLivro;
begin
  Lista := FDAO.CarregarLivros;
  try
    JSONArray := TJSONArray.Create;

    for Livro in Lista do
    begin
      JSONObject := TJSONObject.Create;
      JSONObject.Add('id', Livro.ID);
      JSONObject.Add('titulo', Livro.Titulo);
      JSONObject.Add('autor', Livro.AutorNome);
      JSONObject.Add('ano_publicacao', Livro.Ano);
      JSONObject.Add('isbn', Livro.ISBN);

      JSONArray.Add(JSONObject);
    end;

    Result := JSONArray;
  finally
     Lista.Free;
  end;
end;
end.

