unit mensagens;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, LCLType;

type
  TMensagens = class

    public
      class procedure MsgSalvarSucesso();
      class procedure MsgExcluirSucesso();
      class procedure MsgErro(msg : String);
      class procedure MsgAlerta(msg : String);
      class procedure MsgSucesso(msg : String);
      class procedure MsgHomologacao(idEmpresa : Integer);

      /// <summary>Pergunta padrão "Sim" ou "Não" com ícone de interrogação e retorno mrYes (6) ou mrNo (7).</summary>
      /// <param name="msg">Mensagem a ser perguntada.</param>
      /// <returns>Inteiro: mrYes (6) ou mrNo (7).</returns>
      class function MsgPergunta(msg : String) : Integer;
  end;

implementation

class procedure TMensagens.MsgSalvarSucesso();
begin
  Application.MessageBox('Registro salvo com sucesso!', 'Sucesso', MB_OK + MB_ICONASTERISK);
end;

class procedure TMensagens.MsgExcluirSucesso();
begin
  Application.MessageBox('Registro excluído com sucesso!', 'Sucesso', MB_OK + MB_ICONASTERISK);
end;

class procedure TMensagens.MsgHomologacao(idEmpresa: Integer);
begin
  if (idEmpresa = 159) then
    Application.MessageBox('PROCEDIMENTO EM HOMOLOGAÇÃO!', 'Alerta!', MB_OK + MB_ICONWARNING);
end;

class procedure TMensagens.MsgErro(msg : String);
begin
  if (Trim(msg) = '') then
    Exit;

  Application.MessageBox(PChar(msg), 'Erro!', MB_OK + MB_ICONERROR);
end;

class procedure TMensagens.MsgAlerta(msg : String);
begin
  Application.MessageBox(PChar(msg), 'Alerta!', MB_OK + MB_ICONWARNING);
end;

class procedure TMensagens.MsgSucesso(msg : String);
begin
  Application.MessageBox(PChar(msg), 'Sucesso!', MB_OK + MB_ICONINFORMATION);
end;

class function TMensagens.MsgPergunta(msg : String) : Integer;
begin
  Result := Application.MessageBox(PChar(msg), 'Atenção!', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
end;

end.

