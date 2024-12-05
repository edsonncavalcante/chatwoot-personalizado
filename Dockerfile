
FROM sendingtk/chatwoot:v3.13.8

# Instala dependências do sistema
RUN apk update && apk add --no-cache \
    nodejs-current \
    yarn \
    build-base \
    git \
    postgresql-dev \
    libxml2-dev \
    libxslt-dev \
    file \
    imagemagick

# Define o diretório de trabalho
WORKDIR /app

# Define o ambiente como produção
ENV RAILS_ENV=production
ENV SECRET_KEY_BASE=precompile_placeholder

# Instala dependências Ruby e Yarn
RUN bundle install --without development test
RUN yarn install --check-files

# Copia os arquivos customizados
COPY ./tailwind.config.js /app/tailwind.config.js
COPY branding/*.* /app/public/
COPY app/javascript/dashboard/components/ChatList.vue /app/app/javascript/dashboard/components/ChatList.vue

# Limpa e recompila os assets do Rails
RUN bundle exec rake assets:clean
RUN bundle exec rake assets:precompile --trace
