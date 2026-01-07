unit uFormLogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, MaskEdit, uUsuarioService;

type

  { TFrmLogin }

  TFrmLogin = class(TForm)
    btnEntrar: TButton;
    btnSair: TButton;
    edtEmail: TEdit;
    edtSenha: TEdit;
    Label1: TLabel;
    procedure btnEntrarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.lfm}

{ TFrmLogin }

procedure TFrmLogin.btnEntrarClick(Sender: TObject);
var
  Service : TUsuarioService;
  MsgErro: String;
begin
  Service := TUsuarioService.Create;
  try
    if Service.Autenticar(edtEmail.Text, edtSenha.Text, MsgErro) then
    begin
      ModalResult := mrOK;
    end
    else
    begin
      ShowMessage(MsgErro);

      if MsgErro = 'Senha incorreta.' then
      begin
        edtSenha.Clear;
      end;
    end;
  finally
    Service.Free;
  end;
end;

procedure TFrmLogin.btnSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  edtEmail.SetFocus;
end;

end.

