unit uFormAutor;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, LCLType, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  ExtCtrls, DB, ZDataset, ZConnection, uAutor, uAutoresDAO, uModuloDados,
  uAutorService, mensagens;

type

  { TFrmAutor }

  TFrmAutor = class(TForm)
    AtualizarLabel5: TLabel;
    AtualizarLabel7: TLabel;
    AtualizarLabel8: TLabel;
    btnVoltar: TButton;
    // --- BOTÕES DO MENU (Que mostram as telas) ---
    Criar: TButton;
    Atualizar: TButton;
    Deletar: TButton;
    Inserir: TGroupBox;
    DbGrid: TPanel;
    AtualizarPanel: TPanel;
    DeletarPanel: TPanel;
    ProcurarPanel: TPanel;
    Topo: TPanel;
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
  AtualizarPanel.Visible := false;
  ProcurarPanel.Visible := false;
  DeletarPanel.Visible := false;
  Inserir.Visible := false;
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

  Inserir.Visible := true;

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

  AtualizarPanel.Visible := true;

  EditAtualizar2.Text := ZQuery1.FieldByName('ID').AsString;
  EditAtualizar1.Text := ZQuery1.FieldByName('NOME').AsString;
  EditAtualizar5.Text := ZQuery1.FieldByName('NACIONALIDADE').AsString;

end;

procedure TFrmAutor.DeletarClick(Sender: TObject);
begin
  if ZQuery1.IsEmpty then Exit;

  EsconderTudo;

  DeletarPanel.Visible := true;

  EditDeletar.Text := ZQuery1.FieldByName('ID').AsString;
end;


procedure TFrmAutor.ProcurarClick(Sender: TObject);
begin
  EsconderTudo;

  ProcurarPanel.Visible := true;

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
      if TMensagens.MsgPergunta('Tem certeza que deseja deletar?') = IDYES then
      begin
      Service.Deletar(ID);
      ShowMessage('Autor excluido!');
      end;



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
