unit conexao;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, DB;

type

  { TDataModule2 }

  TDataModule2 = class(TDataModule)
    DataSource1: TDataSource;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
  private

  public

  end;

var
  DataModule2: TDataModule2;

implementation

{$R *.lfm}

end.
