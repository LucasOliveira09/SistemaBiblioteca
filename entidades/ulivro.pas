unit uLivro;
{$mode Delphi}
interface

type
  TLivro = class
  private
    FID: Integer;
    FTitulo: String;
    FAutorID: Integer;
    FAno: Integer;
    FISBN: String;
    FAutorNome: String;
  public
    constructor Create(ID, Ano, AutorID: Integer; Titulo, ISBN: String);
    property ID: Integer read FID write FID;
    property Titulo: String read FTitulo write FTitulo;
    property AutorID: Integer read FAutorID write FAutorID;
    property Ano: Integer read FAno write FAno;
    property ISBN: String read FISBN write FISBN;
    property AutorNome: String read FAutorNome write FAutorNome;
  end;

implementation

constructor TLivro.Create(ID, Ano, AutorID: Integer; Titulo, ISBN: String);
begin
  FID := ID;
  FTitulo := Titulo;
  FAutorID := AutorID;
  FAno := Ano;
  FISBN := ISBN;
  FAutorNome := '';
end;

end.
