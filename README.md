![example workflow](https://github.com/danielnottingham/ypfo/actions/workflows/ci.yml/badge.svg)

## Requerimentos:
- Ruby 3.3.5 (apenas para desenvolvimento local, o Docker cuida das versões)
- Docker
- Docker-Compose

## Iniciando:
1. Clone o repositório para o seu ambiente local.
2. Navegue até o diretório raiz do aplicativo.
3. Crie um arquivo .env baseado no .env.example
```
# ambiente de desenvolvimento
cp .env.example .env
# ambiente de testes
cp .env.test.example .env.test
```
5. Execute o comando `bundle install`
6. Execute o comando para subir os serviços:
```
docker compose up --build -d

# executar os serviços com o ambiente de desenvolvimento
docker compose --env-file .env up -d

# executar os serviços com o ambiente de testes
docker compose --env-file .env.test up -d

# executar os testes após após subir os serviços no ambiente de testes.
docker compose exec app bundle exec rspec
```
7. Suba o servidor:
```
bin/rails server
```

## Acessando a Documentação da API
Você pode visualizar todos os endpoints disponíveis no projeto através do Swagger. Após iniciar o servidor, navegue até:
http://localhost:3000/api-docs/index.html

## Rodando os Testes
Para garantir que tudo está funcionando corretamente e o código não quebre com novas implementações, você pode rodar os testes com o seguinte comando:
```
bundle exec rspec
```
Certifique-se de que todos os testes estão passando antes de submeter alterações.

## Scripts para desenvolvimento:
```
O comando bin/analyze: Executa outros dois scripts.

bin/lint que roda esses dois comandos.
- bundle exec bin/rubocop -A (Rubocop: Analisa o estilo e a conformidade do código Ruby com as boas práticas da comunidade.)
- bundle exec reek (Detecta maus odores de código (code smells) em arquivos Ruby, ajudando a manter o código limpo e legível.)

bin/scan
- bundle exec bin/brakeman (Faz análise estática de segurança para aplicações Ruby on Rails, identificando possíveis vulnerabilidades.)
```
