program BibliotecaDesktop;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, Forms, Controls, SysUtils, Dialogs, uModuloDados, uFormLogin,
  uUsuarioDAO, uAutoresDAO, uEmprestimosDAO, uUsuarioService,
  uEmprestimoService, uLivroService, uAutorService, uAutor, uEmprestimo,
  uFormPrincipal, uFormLivros, uFormAutor, uFormEmprestimo;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;

  try
    GetConnection.Connect;
  except
    on E: Exception do
    begin
      ShowMessage('Erro Crítico: Não foi possível conectar ao banco de dados.' + sLineBreak +
                  'Detalhes: ' + E.Message);
      Application.Terminate;
      Exit;
    end;
  end;

  FrmLogin := TFrmLogin.Create(nil);
  try
    if FrmLogin.ShowModal = mrOK then
    begin


      Application.CreateForm(TFrmPrincipal, FrmPrincipal);

      // Application.CreateForm(TFrmAutores, FrmAutores);


      Application.Run;
    end
    else
    begin
      Application.Terminate;
    end;
  finally
    FrmLogin.Free;
  end;

end.
