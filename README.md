## Sistema para biblioteca ##

## Como baixar o projeto:

Para baixar o projeto acesse o seguinte link: 
[Link](https://github.com/LucasOliveira09/SistemaBiblioteca).

- Após acessar o link Clique no botão verde escrito **<>Code**.
- E então clique em Dowload Zip.
- Vá até a pasta que o download foi efetuado, clique com o botão direito sobre o arquivo e clique em **Winrar -> Extrair aqui**, caso não possua Winrar, 
segue o link para download: (https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-713br.exe)

## Como rodar Desktop:

Para rodar a versão visual do projeto, precisamos acessar a pasta **Desktop** e então clicar duas vezes no arquivo: **project1.exe**

Assim abrirá uma janela para efetuar login e rodar o projeto!
Para efetuar login e visualizar o projeto use o seguinte **Usuario**:

**Usuário**

Email: admin@gmail.com 

**Senha**

Senha: 123

## Como rodar api:

Para rodar a versão de api do sistema, clique na pasta **api**, depois clique no executavel: **api.exe**!

E pronto api iniciada, abrirá uma janaela de prompt de comando, sinalizando a porta que está rodando a Api.

Ele pode ser usado através do postman, a api está configurada para rodar na porta 9000 então geralmente pode ser acessada por esse url: http://localhost:9000

Para usar qualquer rota você pode usar o arquivo .json na pasta Postman para abrir a collection com todas as rotas configuradas!

Pra logar, é necessario lançar o seguinte json na rota **/api/login**:

{"usuario":"admin@gmail.com","senha":"123"}

E salvar o token na variavel token.

Se abrir a collection salva na pasta Postman já estará tudo configurado!

## Requisições:

A api é dividida em 8 requisições, sendo elas:

``` Rotas: TODAS PRECISAM DE TOKEN (menos a de login)

   - POST /api/login - usada para receber token
   - GET /api/livros - lista todos
   - GET /api/livros/:id - detalha um
   - POST /api/livros - cria novo
   - PUT /api/livros/:id - atualiza
   - DELETE /api/livros/:id - deleta
   - GET /api/emprestimos - lista
   - POST /api/emprestimos - cria empréstimo

```

Vamos lá, explicando como usar e como cada uma funciona:


A rota **POST /api/login** é usada para receber o token usado para acessar todas outras rotas!

A rota **GET /api/livros** é usada para listar todos os livros, os livros retornam em um Json!

A rota **GET /api/livros/:id** é usada para procurar um livro atraves de seu id, o id deve ser colocado no final da rota, então receberá um Json do livro!

A rota **POST /api/livros** é usada para cadastrar um novo livro no sistema, sendo necessário enviar os dados do livro no corpo da requisição em formato Json!

``` Json POST /api/livros

{
  "titulo": "O Senhor dos Anéis",
  "autor_id": 1,
  "ano_publicacao": 1954,
  "isbn": "9780007136599"
}

```

A rota **PUT /api/livros/:id** é usada para atualizar as informações de um livro já existente, o id deve ser informado na URL e os novos dados devem ser enviados em um Json!

``` Json PUT /api/livros/1

{
  "nome": "O Senhor dos Anéis",
  "autor_id": 1,
  "ano_publicacao": 1954,
  "isbn": "9780007136599"
}

```

A rota **DELETE /api/livros/:id** é usada para remover um livro do banco de dados, bastando passar o id do livro ao final da rota!

A rota **GET /api/emprestimos** é usada para visualizar todos os empréstimos realizados, retornando uma lista com os dados em Json!

A rota **POST /api/emprestimos** é usada para registrar um novo empréstimo, você deve enviar as informações (como id do usuário e do livro) em um Json! 

``` Json POST /api/emprestimos

{
  "usuario_id": 1,
  "livro_id": 8,
  "data_emprestimo": "05/01/2026"
}

```

## Arquitetura utilizada:

O projeto foi desenvolvido seguindo tecnicas para profissionalizar o sistema, e facilitar futuras manutenções ou automações, sendo essas tecnicas:

**1. Padrão DAO**
Toda a comunicação com o banco de dados Firebird é isolada em classes DAO (ex: uLivroDAO, uUsuarioDAO). Isso permite que o SQL fique separado da regra de negócio e da interface visual.

**2. Camada de Serviço**
Utilizamos classes de serviço (ex: uLivroService) para intermediar a comunicação entre o DAO e a Interface/API. É aqui que as regras de negócio são validadas (ex: verificar se campos obrigatórios estão preenchidos).

**3. API com Horse**
A API foi construída utilizando o framework Horse, conhecido por ser leve e rápido. Ela consome os mesmos Services e DAOs da aplicação Desktop, garantindo que a lógica de negócio seja idêntica nas duas plataformas.

**4. Componentes**
ZeosLib (ZConnection/ZQuery): Utilizado para conexão nativa e performática com o Firebird.

JSON: Toda a troca de dados na API é feita via JSON.
