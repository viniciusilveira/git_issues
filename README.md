# GitIssues

Essa aplicação tem como função única coletar as issues de um determinado repositório e enviar para um webhook após um tempo pré-configurado.

> Elixir, Erlang, Postgres.

---

## Guia de Instalação

Clone o projeto:
  1. `git clone git@github.com:viniciusilveira/git_issues.git`
  2. `cd git_issues`

## Pré-requisitos

- `Elixir 1.14+`
- `Erlang 26+`

---

#### 1. Instalar Erlang e Elixir

Siga as instruções do [guia de instalação](https://github.com/asdf-vm/asdf#setup) para instalar o asdf.

E use o `asdf` para instalar `Elixir` e `Erlang`:

  ```bash
  asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
  asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

  asdf install erlang 26.0
  asdf install elixir 1.14
  ```

#### 2. Executar a Aplicação

Instale as dependências:

```bash
mix deps.get
```

Inicie o servidor com:

  ```bash
  mix phx.server
  ```

Agora sua aplicação Phoenix está em execução em h`ttp://localhost:4000`;

#### 3. Testes

execute:

  ```bash
  mix test
  ```

#### 4. Como utilizar

No arquivo de configuração de cada ambiente, temos um pequeno grupo de configurações conforme o exemplo abaixo:

```elixir
config :git_issues, :github,
  client: GitIssues.Github.Client,
  webhook_client: GitIssues.Github.WebhookClient,
  base_url: "https://api.github.com",
  api_key: "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",
  webhook_url: "https://webhook.site/dd2a09cc-4b90-4f1d-a4e3-a0c1dd53c5b6",
  delay: 0
```

- client => Implementa um client de conexão com o github para efetuar chamadas para o mesmo, não alterar em nenhum ambiente.
- webhook_client => Implementa um client de conexão com o webhook para efetuar chamadas para o mesmo, não alterar em nenhum ambiente.
- base_url => URL da api do github, alterar somente se tiver alguma atualização na api do github, já está configfurada corretamente em todos os ambientes.
- api_key => Para ter um rate maior de requisições para o github, é importante estar autenticado, para isso, gere uma api_key no github seguindo [esse tutorial](https://docs.github.com/pt/enterprise-cloud@latest/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) e preencha nessa envo para que a autenticação funcione.
- webhook_url => URL para onde as issues coletadas serão enviadas, você pode utilizar o `webhook.site` para testar a aplicação
- delay => O Delay de tempo (em horas) que será aguardado entre a coleta das issues e o envio para o webhook.

Preencha cada um desses campos com os dados necessários antes de inicializar a aplicação, após inicializar você pode fazer uma request como no exemplo abaixo:

```
curl --location 'localhost:4000/git-issues/api/v1/issues?username=elixir-lang&repo=elixir'
```

Com a execução dessa chamada, as issues do repositório informado na chamada serão coletadas, salva em memória e, após o tempo definido nas configs, será enviado para o webhook.
