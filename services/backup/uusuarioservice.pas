unit uUsuarioService;

{$mode Delphi}

interface

uses
  SysUtils, uUsuarioDAO, ZDataset;

type
  TUsuarioService = class
  private
    FDAO: TUsuarioDAO;
  public
    constructor Create;
    destructor Destroy; override;
    function Autenticar(AEmail, ASenha: String; out MsgErro: String): Boolean;
  end;

implementation

{ TUsuarioService }

constructor TUsuarioService.Create;
begin
  FDAO := TUsuarioDAO.Create;
end;

destructor TUsuarioService.Destroy;
begin
  FDAO.Free;
  inherited;
end;

function TUsuarioService.Autenticar(AEmail, ASenha: String; out MsgErro: String): Boolean;
var
  Qry: TZQuery;
  SenhaBanco: String;
  IsAtivo: Boolean;
begin
  Result := False;
  MsgErro := '';
  if (Trim(AEmail) = '') or (Trim(ASenha) = '') then
  begin
    MsgErro := 'Informe email e senha.';
    Exit;
  end;

  Qry := FDAO.BuscarPorEmail(AEmail);
  try
    if Qry.IsEmpty then
    begin
      MsgErro := 'Usuário não encontrado.';
      Exit;
    end;

    IsAtivo := Qry.FieldByName('ATIVO').AsBoolean;
    if not IsAtivo then
    begin
      MsgErro := 'Usuário inativo. Acesso negado.';
      Exit;
    end;

    SenhaBanco := Qry.FieldByName('SENHA').AsString;
    if ASenha <> SenhaBanco then
    begin
      MsgErro := 'Senha incorreta.';
      Exit;
    end;

    Result := True;
  finally
    Qry.Free;
  end;
end;

end.
