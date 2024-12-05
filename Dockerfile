FROM sendingtk/chatwoot:v3.13.8

# instala o nodejs e o yarn para que possamos recompilar os assets do rails
RUN apk update && apk add --no-cache \
  nodejs-current \
  yarn

# coloca o diretório de trabalho na pasta app
WORKDIR /app

# informa o ambiente de build como produção
ENV RAILS_ENV=production

# copia o arquivo customizado do tailwind
COPY ./tailwind.config.js /app/tailwind.config.js

# Coloque os arquivos de branding na pasta branding
COPY branding/*.* /app/public/

# limpa os assets do rails
RUN SECRET_KEY_BASE=precompile_placeholder RAILS_ENV=production bundle exec rake assets:clean

# recompila os assets do rails
RUN SECRET_KEY_BASE=precompile_placeholder RAILS_ENV=production bundle exec rake assets:precompile
