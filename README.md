![example workflow](https://github.com/danielnottingham/ypfo/actions/workflows/ci.yml/badge.svg)

## Requerimentos:
- Ruby 3.2.2
- Docker
- Docker-Compose

## Iniciando:
1. Clone o repositório para o seu ambiente local.
2. Navegue até o diretório raiz do aplicativo.
3. Crie um arquivo .env baseado no .env.example
```
$ cp .env.example .env
```
5. Execute o comando bundle install
6. Depois execute o comando para subir os serviços `docker compose up -d`
7. Por fim, execute o comando para subir o servidor `rails server`

## Scripts para desenvolvimento:

```
O comando bin/analyze: Executa outros dois scripts.

bin/lint que roda esses dois comandos.
- bundle exec rubocop -A (Rubocop: Analisa o estilo e a conformidade do código Ruby com as boas práticas da comunidade.)
- bundle exec reek (Detecta maus odores de código (code smells) em arquivos Ruby, ajudando a manter o código limpo e legível.)

bin/scan
- bundle exec brakeman (Faz análise estática de segurança para aplicações Ruby on Rails, identificando possíveis vulnerabilidades.)
```
