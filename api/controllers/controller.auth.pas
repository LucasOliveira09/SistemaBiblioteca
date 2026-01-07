unit controller.auth;

{$mode Delphi}

interface

uses
  SysUtils, StrUtils, DateUtils, Horse, Horse.JWT, fpjson, ZDataset, base64,
  HlpIHashInfo, HlpConverters, HlpHashFactory, fpjwt;

procedure Registry(App : THorse);
procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

uses
  uModuloDados;

procedure Registry(App : THorse);
begin
  App
    .Post('/api/login', Login);
end;

function Base64ToBase64URL(const S: string): string;
begin
  Result := StringReplace(S, '+', '-', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '_', [rfReplaceAll]);
  Result := AnsiReplaceStr(Result, '=', '');
end;

function GerarJWT(nome, id : string) : string;
const
  JWT_KEY = '1234567';
var
  LToken: TJWT;
  LHMAC: IHMAC;
  LSignCalc: String;
  SignatureBytes: TBytes;
  SignatureBase64: string;
begin
  Result := '';

  try
    try
      LToken            := TJWT.Create;
      LToken.JOSE.alg   := 'HS256';
      LToken.JOSE.typ   := 'JWT';
      LToken.Claims.iat := DateTimeToUnix(Now);
      LToken.Claims.exp := DateTimeToUnix(IncHour(Now, 24));
      LToken.Claims.sub := nome;  //Entidade à quem o token pertence (nome do usuário)
      LToken.Claims.aud := id; //Destinatário do token (ID do usuário)

      // Criar HMAC com a chave secreta ANTES de computar a assinatura
      if (LToken.JOSE.alg = 'HS256') then
        LHMAC := THashFactory.THMAC.CreateHMAC(THashFactory.TCrypto.CreateSHA2_256)
      else if (LToken.JOSE.alg = 'HS384') then
        LHMAC := THashFactory.THMAC.CreateHMAC(THashFactory.TCrypto.CreateSHA2_384)
      else if (LToken.JOSE.alg = 'HS512') then
        LHMAC := THashFactory.THMAC.CreateHMAC(THashFactory.TCrypto.CreateSHA2_512)
      else
        raise Exception.Create('[alg] not implemented');

      // Definir a chave ANTES de calcular a assinatura
      LHMAC.Key := TConverters.ConvertStringToBytes(UTF8Encode(JWT_KEY), TEncoding.UTF8);

      // Calcular a assinatura do token (header.payload)
      SignatureBytes := LHMAC.ComputeString(UTF8Encode(Trim(LToken.AsString)), TEncoding.UTF8).GetBytes;
      SetString(SignatureBase64, PAnsiChar(@SignatureBytes[0]), Length(SignatureBytes));
      SignatureBase64 := EncodeStringBase64(SignatureBase64);
      LSignCalc := Base64ToBase64URL(SignatureBase64);

      // Retornar o token completo no formato JSON
      Result := '{"token": "'+ LToken.AsString +'.'+ LSignCalc +'", "tipo": "Bearer"}';
    except
      on E: Exception do
        Result := '{"error": "Erro ao gerar token: ' + E.Message + '"}';
    end;
  finally
    LToken.Free;
  end;
end;

procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  JSONBody: TJSONObject;
  Usuario, Senha: String;
  Query: TZQuery;
  Token: String;
begin
  try
    //Recebe do body da requisição os dados em formato json
    JSONBody := GetJSON(Req.Body) as TJSONObject;
    //extrai os valores do json
    Usuario  := JSONBody.Strings['usuario'];
    Senha    := JSONBody.Strings['senha'];

    Query := TZQuery.Create(nil);
    Query.Connection := GetConnection;
    Query.SQL.Text := 'SELECT ID, NOME FROM USUARIOS WHERE USUARIO = :EMAIL AND SENHA = :SENHA';
    Query.ParamByName('EMAIL').AsString := Usuario;
    Query.ParamByName('SENHA').AsString := Senha;
    Query.Open;

    if not Query.Eof then
    begin
      Token := GerarJWT(Query.FieldByName('NOME').AsString, Query.FieldByName('ID').AsString);
      Res.Status(200).ContentType('application/json').Send(Token);
    end
    else
      Res.Status(401).Send('Usuário ou senha inválidos');

    Query.Close;
    Query.Free;
  except
    on E: Exception do
      Res.Status(500).Send('Erro: ' + E.Message);
  end;
end;

end.
