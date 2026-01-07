unit uEmprestimosController;

{$mode Delphi}

interface

uses
  Horse, SysUtils, fpjson, jsonparser, ZConnection, uEmprestimoService, uEmprestimo, uModuloDados;

procedure Registry(App : THorse);
procedure GetEmprestimos(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure PostEmprestimo(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);


implementation

procedure Registry(App : THorse);
begin
  App
    .Get('/api/emprestimo', GetEmprestimos)
    .Post('/api/emprestimo', PostEmprestimo)
end;

procedure GetEmprestimos(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  Service : TEmprestimoService;
  JSONArray: TJSONArray;
begin
  Service := TEmprestimoService.Create(GetConnection);
  try
    try
      JSONArray := Service.CarregarEmprestimos;

        Res.ContentType('application/json');
        Res.Send(JSONArray.AsJSON);
    finally
      Service.Free;
      JSONArray.Free;
    end;
  except
    on E: Exception do
      Res.Status(500).Send('Erro: ' + E.Message);
  end;
end;

procedure PostEmprestimo(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  JSONBody: TJSONObject;
  UsuarioID, LivroID: Integer;
  DataEmprestimoStr : String;
  DataEmprestimo : TDateTime;
  Service : TEmprestimoService;
begin
  Service := TEmprestimoService.Create(GetConnection);
  try
    JSONBody := GetJSON(Req.Body) as TJSONObject;
    try
      UsuarioID := JSONBody.Integers['usuario_id'];
      LivroID := JSONBody.Integers['livro_id'];
      DataEmprestimoStr := JSONBody.Strings['data_emprestimo'];

      DataEmprestimo := StrToDate(DataEmprestimoStr);


      try
        Service.CriarEmprestimo(UsuarioID, LivroID, DataEmprestimo);
      finally
      end;

      Res.Status(201).Send('Emprestimo criado com sucesso');
    finally
      JSONBody.Free;
    end;
  except
    on E: Exception do
      Res.Status(400).Send('Erro: ' + E.Message);
  end;
end;
end.


