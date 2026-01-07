unit uAutor;

{$mode Delphi}

interface

type
  TAutor = class
  private
    FID: Integer;
    FNome: String;
    FNacionalidade: String;
  public
    constructor Create(ID: Integer; Nome, Nacionalidade: String);
    property ID: Integer read FID write FID;
    property Nome: String read FNome write FNome;
    property Nacionalidade: String read FNacionalidade write FNacionalidade;
  end;

implementation

constructor TAutor.Create(ID: Integer; Nome, Nacionalidade: String);
begin
  FID := ID;
  FNome := Nome;
  FNacionalidade := Nacionalidade;
end;

end.
