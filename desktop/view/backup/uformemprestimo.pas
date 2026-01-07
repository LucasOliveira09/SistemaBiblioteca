unit uFormEmprestimo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids, DB,
  ZDataset, uEmprestimosDAO, uModuloDados;

type

  { TFrmEmprestimo }

  TFrmEmprestimo = class(TForm)
    Button1: TButton;
    Button2: TButton;
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    Edit1: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Query: TZQuery;


    procedure btnVoltarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure Edit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    DAO: TEmprestimosDAO;

  public

  end;

var
  FrmEmprestimo: TFrmEmprestimo;

implementation

{$R *.lfm}

procedure TFrmEmprestimo.FormShow(Sender: TObject);
begin
  DAO := TEmprestimosDAO.Create(GetConnection);
  try
    DAO.ListarEmprestimosParaDataset(Query);



  except
    on E: Exception do
      ShowMessage('Erro ao carregar empréstimos: ' + E.Message);
  end;
end;

procedure TFrmEmprestimo.FormClose(Sender: TObject);
begin
  if Assigned(DAO) then
  begin
    DAO.Free;
    DAO := nil;
  end;
end;

procedure TFrmEmprestimo.btnVoltarClick(Sender: TObject);
begin

end;

procedure TFrmEmprestimo.Button1Click(Sender: TObject);
var
  ID : String;
begin
  DAO := TEmprestimosDAO.Create(GetConnection);
  try
    ID := Edit1.Text;
    DAO.ListarEmprestimosPorId(Query, StrToInt(ID));
  except
    on E: Exception do
      ShowMessage('Erro ao achar Id: ' + E.Message);
  end;
end;

procedure TFrmEmprestimo.Button2Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmEmprestimo.DataSourceDataChange(Sender: TObject; Field: TField);
begin

end;

procedure TFrmEmprestimo.Edit1Change(Sender: TObject);
begin

end;


end.

