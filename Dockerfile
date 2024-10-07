# syntax = docker/dockerfile:1

# Definir a versão do Ruby como um argumento
ARG RUBY_VERSION=3.3.5
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Definir diretório de trabalho
WORKDIR /rails

# Instalar pacotes base
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Definir ambiente padrão como development
ARG RAILS_ENV="development"
ENV RAILS_ENV="${RAILS_ENV}" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Etapa de build
FROM base AS build

# Instalar dependências de build
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copiar Gemfile e Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instalar gems, removendo aquelas desnecessárias para o ambiente
RUN if [ "$RAILS_ENV" = "production" ]; then \
        bundle config set without 'development test'; \
    else \
        bundle config unset without; \
    fi && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copiar código da aplicação
COPY . .

# Pré-compilar código para melhorar tempos de inicialização
RUN bundle exec bootsnap precompile app/ lib/

# Etapa final para a imagem do app
FROM base

# Copiar gems e código da etapa de build
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Permissões de segurança para rodar como usuário não-root
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Usar script de inicialização para preparar o banco de dados e servidor
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expor porta 3000 para acessar o servidor Rails
EXPOSE 3000

# Definir o comando padrão para rodar o servidor Rails
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
