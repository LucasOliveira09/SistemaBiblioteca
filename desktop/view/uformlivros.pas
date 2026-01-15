unit uFormLivros;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  ExtCtrls, DB, ZDataset, ZConnection, uLivro, uLivroDAO, uModuloDados,
  uLivroService;

type

  { TFrmLivros }

  TFrmLivros = class(TForm)
    AtualizarLabel5: TLabel;
    AtualizarLabel6: TLabel;
    AtualizarLabel7: TLabel;
    AtualizarLabel8: TLabel;
    btnVoltar: TButton;
    // --- BOTÕES DO MENU (Que mostram as telas) ---
    Criar: TButton;
    Atualizar: TButton;
    Deletar: TButton;
    DBGridPanel: TPanel;
    AtualizarPanel: TPanel;
    InserirPanel: TPanel;
    DeletarPanel: TPanel;
    ProcurarPanel: TPanel;
    TopoPanel: TPanel;
    Procurar: TButton;
    Voltar: TButton;

    // --- GRUPO: LISTAGEM ---
    DBGrid1: TDBGrid;
    Label1: TLabel; // Título

    // --- GRUPO: CRIAÇÃO ---
    BtnCriar: TButton;
    CriarLabel: TLabel;
    EditCriar: TEdit;
    EditCriar2: TEdit;
    EditCriar3: TEdit;
    EditCriar4: TEdit;
    CriarLabel1: TLabel;
    CriarLabel2: TLabel;
    CriarLabel3: TLabel;
    AtualizarLabel4: TLabel;
    // ... outros labels de criar

    // --- GRUPO: ATUALIZAÇÃO ---
    BtnAtualizar: TButton; // Botão de Salvar Alteração
    EditAtualizar1: TEdit;
    EditAtualizar2: TEdit;
    EditAtualizar5: TEdit;
    EditAtualizar6: TEdit;
    EditAtualizar7: TEdit;

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
    DAO : TLivroDAO;
    procedure EsconderTudo;

  public
  end;

var
  FrmLivros: TFrmLivros;

implementation

{$R *.lfm}

{ TFrmLivros }

// 1. O SEGREDO: Uma função que esconde TODOS os inputs e botões de ação
procedure TFrmLivros.EsconderTudo;
begin
 InserirPanel.Visible := false;
 DeletarPanel.Visible := false;
 ProcurarPanel.Visible := false;
 AtualizarPanel.Visible := false;
end;

// 2. Inicialização
procedure TFrmLivros.FormShow(Sender: TObject);
begin
  DAO := TLivroDAO.Create(GetConnection);

  // Liga os dados
  DataSource1.DataSet := ZQuery1;
  DBGrid1.DataSource := DataSource1;

  DAO.ListarLivrosParaDataset(ZQuery1);

  // Começa com tudo limpo (só grid e menu)
  EsconderTudo;
end;

procedure TFrmLivros.AtualizarLabel5Click(Sender: TObject);
begin

end;

procedure TFrmLivros.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(FQueryLivros) then FQueryLivros.Free;
  if Assigned(DAO) then DAO.Free;
end;

procedure TFrmLivros.CriarClick(Sender: TObject);
begin
  EsconderTudo;

  InserirPanel.Visible := true;

  EditCriar.Clear;
  EditCriar2.Clear;
  EditCriar3.Clear;
  EditCriar4.Clear;

end;

procedure TFrmLivros.AtualizarClick(Sender: TObject);
begin
  if ZQuery1.IsEmpty then
  begin
    ShowMessage('Selecione um livro na tabela primeiro!');
    Exit;
  end;

  EsconderTudo;

  AtualizarPanel.Visible := true;

  EditAtualizar2.Text := ZQuery1.FieldByName('ID').AsString;
  EditAtualizar1.Text := ZQuery1.FieldByName('TITULO').AsString;
  EditAtualizar6.Text := ZQuery1.FieldByName('AUTOR').AsString;
  EditAtualizar5.Text := ZQuery1.FieldByName('ANO_PUBLICACAO').AsString;
  EditAtualizar7.Text := ZQuery1.FieldByName('ISBN').AsString;

end;

procedure TFrmLivros.DeletarClick(Sender: TObject);
begin
  if ZQuery1.IsEmpty then
  begin
    ShowMessage('Selecione um livro na tabela primeiro!');
    Exit;
  end;

  EsconderTudo;

  DeletarPanel.Visible := true;

  EditDeletar.Text := ZQuery1.FieldByName('ID').AsString;
end;

procedure TFrmLivros.ProcurarClick(Sender: TObject);
begin
  EsconderTudo;

  ProcurarPanel.Visible := true;

  EditProcurar.SetFocus;
end;

procedure TFrmLivros.btnVoltarClick(Sender: TObject);
begin
    Self.Close;

    EsconderTudo;

    if Assigned(DAO) then DAO.ListarLivrosParaDataset(ZQuery1);

end;


// ==========================================================

procedure TFrmLivros.BtnCriarClick(Sender: TObject);
var
  Service : TLivroService;
  Titulo, ISBN : String;
  Ano, AutorID : Integer;
begin
  Service := TLivroService.Create(GetConnection);
  try
    Titulo  := EditCriar.Text;
    Ano     := StrToIntDef(EditCriar2.Text, 0);
    AutorID := StrToIntDef(EditCriar3.Text, 0);
    ISBN    := EditCriar4.Text;

    Service.CriarLivro(Titulo, ISBN, AutorID, Ano);

    ShowMessage('Livro criado com sucesso!');

    EsconderTudo;
    DAO.ListarLivrosParaDataset(ZQuery1);

  finally
    Service.Free;
  end;
end;

procedure TFrmLivros.BtnAtualizarClick(Sender: TObject);
var
  Service: TLivroService;
  Livro: TLivro;
  Titulo, ISBN : String;
  ID, Ano, AutorID: Integer;
begin
  Service := TLivroService.Create(GetConnection);
  try
    ID      := StrToIntDef(EditAtualizar2.Text, 0);
    Titulo  := EditAtualizar1.Text;
    Ano     := StrToIntDef(EditAtualizar5.Text, 0);
    AutorID := StrToIntDef(EditAtualizar6.Text, 0);
    ISBN    := EditAtualizar7.Text;

    Livro := TLivro.Create(ID, Ano, AutorID, Titulo, ISBN);
    try
      Service.AtualizarLivro(Livro);
    finally
      Livro.Free;
    end;

    ShowMessage('Livro Atualizado!');

    EsconderTudo;
    DAO.ListarLivrosParaDataset(ZQuery1);
  except
    on E: Exception do ShowMessage('Erro: ' + E.Message);
  end;
  Service.Free;
end;

procedure TFrmLivros.BtnDeletarClick(Sender: TObject);
var
  ID: Integer;
  Service : TLivroService;
begin
  ID := StrToIntDef(EditDeletar.Text, 0);
  Service := TLivroService.Create(GetConnection);
  try
    if MessageDlg('Tem certeza?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Service.Deletar(ID);
      ShowMessage('Livro Excluído!');

      EsconderTudo;
      DAO.ListarLivrosParaDataset(ZQuery1);
    end;
  finally
    Service.Free;
  end;
end;

procedure TFrmLivros.BtnProcurarClick(Sender: TObject);
var
  Service: TLivroService;
begin
  Service := TLivroService.Create(GetConnection);
  try
    Service.FiltrarLivros(ZQuery1, EditProcurar.Text);

    DBGrid1.Visible := True;
  finally
    Service.Free;
  end;
end;

procedure TFrmLivros.DBGrid1CellClick(Column: TColumn); begin end;

end.
