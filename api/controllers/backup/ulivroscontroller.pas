unit uLivrosController;

{$mode Delphi}

interface

uses
  Horse, SysUtils, fpjson, jsonparser, ZConnection, uLivroService, uLivro, uModuloDados;

procedure Registry(App : THorse);
procedure GetLivros(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure GetLivro(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure PostLivro(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure PutLivro(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure DeleteLivro(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure Registry(App : THorse);
begin
  App
    .Get('/api/livro', GetLivros)
    .Get('/api/livro/:id', GetLivro)
    .Post('/api/livro', PostLivro)
    .Put('/api/livro/:id', PutLivro)
    .Delete('/api/livro/:id', DeleteLivro);
end;

procedure GetLivros(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  Service : TLivroService;
  JSONArray: TJSONArray;
begin
  Service := TLivroService.Create(GetConnection);
  try
    try
      JSONArray := Service.CarregarLivros;

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

procedure GetLivro(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  Service : TLivroService;
  JSONObject: TJSONObject;
  ID : string;
  Livro : TLivro;
begin
  Service := TLivroService.Create(GetConnection);
  try
    ID := Req.Params.Items['id'];
    JSONObject := TJSONObject.Create;
    try
      Livro := Service.BuscarPorID(StrToInt(ID));
      begin
        JSONObject := TJSONObject.Create;
        JSONObject.Add('id', Livro.ID);
        JSONObject.Add('titulo', Livro.Titulo);
        JSONObject.Add('autor_id', Livro.AutorID);
        JSONObject.Add('ano_publicacao', Livro.Ano);
        JSONObject.Add('isbn', Livro.ISBN);

        Res.ContentType('application/json');
        Res.Send(JSONObject.AsJSON);
      end

    finally
      Service.Free;
      JSONObject.Free;
    end;
  except
    on E: Exception do
      Res.Status(500).Send('Erro: ' + E.Message);
  end;
end;

procedure PostLivro(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  JSONBody: TJSONObject;
  Titulo, ISBN: String;
  AutorID, Ano : Integer;
  Service : TLivroService;
begin
  Service := TLivroService.Create(GetConnection);
  try
    JSONBody := GetJSON(Req.Body) as TJSONObject;
    try
      Titulo     := JSONBody.Strings['titulo'];
      ISBN    := JSONBody.Strings['isbn'];
      AutorID := JSONBody.Strings['autor_id'];
      Ano := JSONBody.Strings['ano_publicacao'];

      try
        Service.CriarLivro(Titulo, ISBN, StrToInt(AutorID), StrToInt(Ano));
      finally
      end;

      Res.Status(201).Send('Cliente criado com sucesso');
    finally
      JSONBody.Free;
    end;
  except
    on E: Exception do
      Res.Status(400).Send('Erro: ' + E.Message);
  end;
end;

procedure PutLivro(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  JSONBody: TJSONObject;
  Service: TLivroService;
  Livro: TLivro;
  ID, AutorID, Ano: Integer;
  Titulo, ISBN: String;
begin
  Service := TLivroService.Create(GetConnection);
  try
    ID := StrToIntDef(Req.Params['id'], 0);
    JSONBody := GetJSON(Req.Body) as TJSONObject;

    try
      Titulo  := JSONBody.Strings['nome'];
      AutorID := JSONBody.Integers['autor_id'];
      Ano := JSONBody.Integers['ano_publicacao'];
      ISBN := JSONBody.Strings['isbn'];
      try
        Livro := TLivro.Create(ID, Ano, AutorID, Titulo, ISBN);
        Service.AtualizarLivro(Livro);
      finally
        Livro.Free;
        Service.Free;
      end;

      Res.Send('Livro atualizado com sucesso');
    finally
      JSONBody.Free;
    end;
  except
    on E: Exception do
      Res.Status(400).Send('Erro: ' + E.Message);
  end;
end;

procedure DeleteLivro(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  ID: Integer;
  Service: TLivroService;
begin
  Service := TLivroService.Create(GetConnection);
  try
    ID := StrToInt(Req.Params['id']);
    try
     Service.Deletar(ID);
    finally
      Service.Free;
    end;

    Res.Send('Cliente deletado com sucesso');
  except
    on E: Exception do
      Res.Status(400).Send('Erro: ' + E.Message);
  end;
end;
end.

