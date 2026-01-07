program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, Forms, zcomponent, uLivroService, uUsuarioService, uAutor,
  uEmprestimo, uLivro, uLivrosController, uModuloDados, uLivroDAO, uAutoresDAO,
  uEmprestimosDAO;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  {$PUSH}{$WARN 5044 OFF}
  Application.MainFormOnTaskbar:=True;
  {$POP}
  Application.Initialize;
  Application.CreateForm(TDataModule2, DataModule2);
  Application.Run;
end.

