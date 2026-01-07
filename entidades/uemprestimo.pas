unit uEmprestimo;

{$mode Delphi}

interface

uses
  SysUtils;

type
  TEmprestimo = class
  private
    FID: Integer;
    FUsuarioID: Integer;
    FLivroID: Integer;
    FDataEmprestimo: TDateTime;
    FDataDevolucao: TDateTime;
  public
    constructor Create(ID, UsuarioID, LivroID: Integer; DataEmprestimo, DataDevolucao: TDateTime);

    property ID: Integer read FID write FID;
    property UsuarioID: Integer read FUsuarioID write FUsuarioID;
    property LivroID: Integer read FLivroID write FLivroID;
    property DataEmprestimo: TDateTime read FDataEmprestimo write FDataEmprestimo;
    property DataDevolucao: TDateTime read FDataDevolucao write FDataDevolucao;
  end;

implementation

  constructor TEmprestimo.Create(ID, UsuarioID, LivroID: Integer; DataEmprestimo, DataDevolucao: TDateTime);
  begin
    FID := ID;
    FUsuarioID := UsuarioID;
    FLivroID := LivroID;
    FDataEmprestimo := DataEmprestimo;
    FDataDevolucao := DataDevolucao;
  end;

end.
