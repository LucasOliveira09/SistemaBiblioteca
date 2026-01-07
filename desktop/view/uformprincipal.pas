unit uFormPrincipal;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ExtCtrls, ComCtrls,
  StdCtrls;

type

  { TFrmPrincipal }

  TFrmPrincipal = class(TForm)
    btnLivros: TButton;
    btnAutores: TButton;
    btnEmprestimos: TButton;
    inutil: TLabel;
    procedure btnAutoresClick(Sender: TObject);
    procedure btnEmprestimosClick(Sender: TObject);
    procedure btnLivrosClick(Sender: TObject);
  private

  public

  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  uFormLivros, uFormAutor, uFormEmprestimo;

{$R *.lfm}

{ TFrmPrincipal }

procedure TFrmPrincipal.btnLivrosClick(Sender: TObject);
begin
 Self.Hide;
 if not Assigned(FrmLivros) then
    FrmLivros := TFrmLivros.Create(nil);

  try

    FrmLivros.ShowModal;
  finally

    FreeAndNil(FrmLivros);
    Self.Show;
  end;
end;

procedure TFrmPrincipal.btnAutoresClick(Sender: TObject);
begin
 Self.Hide;
 if not Assigned(FrmAutor) then
    FrmAutor := TFrmAutor.Create(nil);

  try

    FrmAutor.ShowModal;
  finally

    FreeAndNil(FrmAutor);
    Self.Show;
  end;
end;

procedure TFrmPrincipal.btnEmprestimosClick(Sender: TObject);
begin
  Self.Hide;
 if not Assigned(FrmEmprestimo) then
    FrmEmprestimo := TFrmEmprestimo.Create(nil);

  try

    FrmEmprestimo.ShowModal;
  finally

    FreeAndNil(FrmEmprestimo);
    Self.Show;
  end;
end;

{ TFrmPrincipal }



end.
