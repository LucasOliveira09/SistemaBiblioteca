unit uEmprestimoService;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  ZConnection, fpjson, jsonparser,
  uEmprestimosDAO, uEmprestimo, Generics.Collections;

type
  { TEmprestimoService }
  TEmprestimoService = class
  private
    FDAO: TEmprestimosDAO;
  public
    constructor Create(Connection: TZConnection);
    destructor Destroy; override;


    procedure CriarEmprestimo(UsuarioId, LivroId: Integer; DataEmprestimo: TDateTime);
    function ValidarDados(UsuarioId, LivroId: Integer; DataEmprestimo: TDateTime): Boolean;
    function CarregarEmprestimos: TJSONArray;
  end;

implementation

constructor TEmprestimoService.Create(Connection: TZConnection);
begin
  FDAO := TEmprestimosDAO.Create(Connection);
end;

destructor TEmprestimoService.Destroy;
begin
  FDAO.Free;
  inherited;
end;

function TEmprestimoService.ValidarDados(UsuarioId, LivroId: Integer; DataEmprestimo: TDateTime): Boolean;
begin
  Result := (UsuarioId > 0) and
            (FDAO.VerificarLivro(LivroId)) and
            (DataEmprestimo > 0);
end;

procedure TEmprestimoService.CriarEmprestimo(UsuarioId, LivroId: Integer; DataEmprestimo: TDateTime);
var
  Emprestimo: TEmprestimo;
begin
  if not ValidarDados(UsuarioId, LivroId, DataEmprestimo) then
    raise Exception.Create('Dados inválidos. Verifique o Usuário, o Livro e a Data.');

  Emprestimo := TEmprestimo.Create(0, UsuarioId, LivroId, DataEmprestimo, 0);
  try
    FDAO.Inserir(Emprestimo);
  finally
    Emprestimo.Free;
  end;
end;

function TEmprestimoService.CarregarEmprestimos: TJSONArray;
var
  Lista: TListaEmprestimos;
  JSONObject: TJSONObject;
  JSONArray: TJSONArray;
  Emprestimo: TEmprestimo;
begin
  Lista := FDAO.CarregarEmprestimos;
  try
    JSONArray := TJSONArray.Create;

    if Assigned(Lista) then
    begin
      for Emprestimo in Lista do
      begin
        JSONObject := TJSONObject.Create;

        JSONObject.Add('id', Emprestimo.ID);
        JSONObject.Add('usuario_id', Emprestimo.UsuarioId);
        JSONObject.Add('livro_id', Emprestimo.LivroId);
        JSONObject.Add('data_emprestimo', DateToStr(Emprestimo.DataEmprestimo));

        if Emprestimo.DataDevolucao > 0 then
          JSONObject.Add('data_devolucao', DateToStr(Emprestimo.DataDevolucao))
        else
          JSONObject.Add('data_devolucao', 'Pendente');

        JSONArray.Add(JSONObject);
      end;
    end;

    Result := JSONArray;
  finally
    Lista.Free;
  end;
end;

end.
