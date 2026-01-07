unit uFormAutor;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids, DB,
  ZDataset, ZConnection, uAutor, uAutoresDAO, uModuloDados, uAutorService;

type

  TFrmAutor = class(TForm)
    AtualizarLabel5: TLabel;
    AtualizarLabel7: TLabel;
    AtualizarLabel8: TLabel;
    btnVoltar: TButton;
    // --- BOTÕES DO MENU (Que mostram as telas) ---
    Criar: TButton;
    Atualizar: TButton;
    Deletar: TButton;
    Procurar: TButton;
    Voltar: TButton;

    // --- GRUPO: LISTAGEM ---
    DBGrid1: TDBGrid;
    Label1: TLabel;

    // --- GRUPO: CRIAÇÃO ---
    BtnCriar: TButton;
    EditCriar3: TEdit;
    EditCriar4: TEdit;
    CriarLabel1: TLabel;
    CriarLabel3: TLabel;

    // --- GRUPO: ATUALIZAÇÃO ---
    BtnAtualizar: TButton;
    EditAtualizar1: TEdit;
    EditAtualizar2: TEdit;
    EditAtualizar5: TEdit;

    // --- GRUPO: DELEÇÃO ---
    BtnDeletar: TButton; // Botão de Confirmar Exclusão
    DeletarLabel: TLabel;
    EditDeletar: TEdit;

    // --- GRUPO: PROCURAR ---
    BtnProcurar: TButton; // Botão de Executar Busca
    ProcurarLabel: TLabel;
    EditProcurar: TEdit;

    // --- DADOS ---
    DataSource1: TDataSource;
    ZQuery1: TZQuery;

    // --- EVENTOS ---
    procedure AtualizarLabel5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);

    // Cliques do Menu (Mudam a tela)
    procedure BtnCriarClick(Sender: TObject);
    procedure BtnAtualizarClick(Sender: TObject);
    procedure BtnDeletarClick(Sender: TObject);
    procedure BtnProcurarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);

    // Cliques de Ação (Banco de Dados)
    procedure CriarClick(Sender: TObject);
    procedure AtualizarClick(Sender: TObject);
    procedure DeletarClick(Sender: TObject);
    procedure ProcurarClick(Sender: TObject);

    // Auxiliar
    procedure DBGrid1CellClick(Column: TColumn);

  private
    FQueryLivros : TZQuery;
    DAO : TAutoresDAO;
    procedure EsconderTudo;

  public
  end;

var
  FrmAutor: TFrmAutor;

implementation

{$R *.lfm}

procedure TFrmAutor.EsconderTudo;
begin
  BtnCriar.Visible := False;
  EditCriar3.Visible := False;
  EditCriar4.Visible := False;
  CriarLabel1.Visible := False;
  CriarLabel3.Visible := False;

  // Esconde Grupo Atualizar
  BtnAtualizar.Visible := False;
  EditAtualizar1.Visible := False;
  EditAtualizar2.Visible := False;
  EditAtualizar5.Visible := False;
  AtualizarLabel5.Visible := False;
  AtualizarLabel8.Visible := False;
  AtualizarLabel7.Visible := False;



  // Esconde Grupo Deletar
  BtnDeletar.Visible := False;
  DeletarLabel.Visible := False;
  EditDeletar.Visible := False;

  // Esconde Grupo Procurar
  BtnProcurar.Visible := False;
  ProcurarLabel.Visible := False;
  EditProcurar.Visible := False;

  // Grid e Botões de Menu ficam visíveis por padrão,
  DBGrid1.Visible := True;
  Criar.Visible := True;
  Atualizar.Visible := True;
  Deletar.Visible := True;
  Procurar.Visible := True;
end;

procedure TFrmAutor.FormShow(Sender: TObject);
begin
  DAO := TAutoresDAO.Create(GetConnection);

  DataSource1.DataSet := ZQuery1;
  DBGrid1.DataSource := DataSource1;

  DAO.ListarAutoresParaDataset(ZQuery1);

  EsconderTudo;
end;

procedure TFrmAutor.AtualizarLabel5Click(Sender: TObject);
begin

end;

procedure TFrmAutor.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(FQueryLivros) then FQueryLivros.Free;
  if Assigned(DAO) then DAO.Free;
end;

// ==========================================================
// 3. EVENTOS DO MENU (BTN...) - AQUI A MÁGICA DE EXIBIÇÃO
// ==========================================================

procedure TFrmAutor.CriarClick(Sender: TObject);
begin
  EsconderTudo;

  Criar.Visible := True;
  EditCriar3.Visible := True;
  EditCriar4.Visible := True;
  CriarLabel1.Visible := True;
  CriarLabel3.Visible := True;
  BtnCriar.Visible := True;

  EditCriar3.Clear;
  EditCriar4.Clear;

end;

procedure TFrmAutor.AtualizarClick(Sender: TObject);
begin
  if ZQuery1.IsEmpty then
  begin
    ShowMessage('Selecione um autor na tabela primeiro!');
    Exit;
  end;

  EsconderTudo;

  BtnAtualizar.Visible := True;

  EditAtualizar1.Visible := True;
  EditAtualizar2.Visible := True;
  EditAtualizar5.Visible := True;

  AtualizarLabel5.Visible := True;
  AtualizarLabel7.Visible := True;
  AtualizarLabel8.Visible := True;

  EditAtualizar2.Text := ZQuery1.FieldByName('ID').AsString;
  EditAtualizar1.Text := ZQuery1.FieldByName('NOME').AsString;
  EditAtualizar5.Text := ZQuery1.FieldByName('NACIONALIDADE').AsString;

end;

procedure TFrmAutor.DeletarClick(Sender: TObject);
begin
  if ZQuery1.IsEmpty then Exit;

  EsconderTudo;

  BtnDeletar.Visible := True;
  DeletarLabel.Visible := True;
  EditDeletar.Visible := True;

  EditDeletar.Text := ZQuery1.FieldByName('ID').AsString;
end;

procedure TFrmAutor.ProcurarClick(Sender: TObject);
begin
  EsconderTudo;

  BtnProcurar.Visible := True;
  ProcurarLabel.Visible := True;
  EditProcurar.Visible := True;

  EditProcurar.SetFocus;
end;

procedure TFrmAutor.btnVoltarClick(Sender: TObject);
begin
    Self.Close;

    EsconderTudo;
    if Assigned(DAO) then DAO.ListarAutoresParaDataset(ZQuery1);

end;


// ==========================================================

procedure TFrmAutor.BtnCriarClick(Sender: TObject);
var
  Service : TAutorService;
  Nome, Nacionalidade : String;
begin
  Service := TAutorService.Create(GetConnection);
  try
    Nome := EditCriar3.Text;
    Nacionalidade := EditCriar4.Text;

    Service.CriarAutor(Nome, Nacionalidade);

    ShowMessage('Autor criado com sucesso!');

    EsconderTudo;
    DAO.ListarAutoresParaDataset(ZQuery1);
  finally
    Service.Free;
  end;
end;

procedure TFrmAutor.BtnAtualizarClick(Sender: TObject);
var
  Service: TAutorService;
  Autor: TAutor;
  Nome, Nacionalidade : String;
  ID: Integer;
begin
  Service := TAutorService.Create(GetConnection);
  try
    ID := StrToIntDef(EditAtualizar2.Text, 0);
    Nome := EditAtualizar1.Text;
    Nacionalidade := EditAtualizar5.Text;

    Autor := TAutor.Create(ID, Nome, Nacionalidade);
    try
      Service.AtualizarAutor(Autor);
    finally
      Autor.Free;
    end;

    ShowMessage('Autor Atualizado!');

    EsconderTudo;
    DAO.ListarAutoresParaDataset(ZQuery1);
  except
    on E: Exception do ShowMessage('Erro: ' + E.Message);
  end;
  Service.Free;
end;

procedure TFrmAutor.BtnDeletarClick(Sender: TObject);
var
  ID: Integer;
  Service : TAutorService;
begin
  ID := StrToIntDef(EditDeletar.Text, 0);

  Service := TAutorService.Create(GetConnection);
  try
      Service.Deletar(ID);
      ShowMessage('Autor Excluído!');

      EsconderTudo;
      DAO.ListarAutoresParaDataset(ZQuery1);
  finally
    Service.Free;
  end;
end;

procedure TFrmAutor.BtnProcurarClick(Sender: TObject);
var
  Service: TAutorService;
begin
  Service := TAutorService.Create(GetConnection);
  try
    Service.Filtrar(ZQuery1, EditProcurar.Text);
    DBGrid1.Visible := True;
  finally
    Service.Free;
  end;
end;

procedure TFrmAutor.DBGrid1CellClick(Column: TColumn); begin end;

end.
