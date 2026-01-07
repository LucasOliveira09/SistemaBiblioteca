unit uAutorService;

{$mode Delphi}

interface

uses
  Classes, SysUtils, ZDataset, ZConnection, uAutoresDAO, uAutor;

type
  TAutorService = class
  private
    FDAO: TAutoresDAO;
  public
    constructor Create(AConnection: TZConnection);
    destructor Destroy; override;

    procedure CriarAutor(Nome, Nacionalidade: String);
    procedure AtualizarAutor(Autor: TAutor);
    procedure Deletar(Id: Integer);
    procedure Filtrar(AQuery: TZQuery; Filtro: String);
  end;

implementation

constructor TAutorService.Create(AConnection: TZConnection);
begin
  FDAO := TAutoresDAO.Create(AConnection);
end;

destructor TAutorService.Destroy;
begin
  FDAO.Free;
  inherited;
end;

procedure TAutorService.CriarAutor(Nome, Nacionalidade: String);
var
  Autor: TAutor;
begin
  if Trim(Nome) = '' then
    raise Exception.Create('O nome do autor é obrigatório.');

  Autor := TAutor.Create(0, Nome, Nacionalidade);
  try
    FDAO.Inserir(Autor);
  finally
    Autor.Free;
  end;
end;

procedure TAutorService.AtualizarAutor(Autor: TAutor);
begin
  if Trim(Autor.Nome) = '' then
    raise Exception.Create('O nome do autor é obrigatório.');

  FDAO.Atualizar(Autor);
end;

procedure TAutorService.Deletar(Id: Integer);
begin
  if Id <= 0 then raise Exception.Create('ID inválido.');
  FDAO.Deletar(Id);
end;

procedure TAutorService.Filtrar(AQuery: TZQuery; Filtro: String);
begin
  FDAO.FiltrarAutoresPorNome(AQuery, Trim(Filtro));
end;

end.
