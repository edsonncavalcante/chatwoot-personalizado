FROM sendingtk/chatwoot:v3.13.8

# Atualiza os pacotes e instala Node.js e Yarn
RUN apk update && apk add --no-cache \
    nodejs \
    npm \
    yarn

# Define o diretório de trabalho
WORKDIR /app

# Define o ambiente como produção
ENV RAILS_ENV=production

# Copia o arquivo customizado do Tailwind
COPY ./tailwind.config.js /app/tailwind.config.js

# Copia os arquivos de branding para o diretório público
COPY branding/* /app/public/

# Copia o componente Vue.js personalizado
COPY ./app/javascript/dashboard/components/ChatList.vue /app/app/javascript/dashboard/components/ChatList.vue

# Garante que todas as dependências estejam instaladas corretamente
RUN yarn install --check-files
RUN bundle install --without development test

# Limpa os assets do Rails
RUN SECRET_KEY_BASE=precompile_placeholder RAILS_ENV=production bundle exec rake assets:clean

# Recompila os assets do Rails
RUN SECRET_KEY_BASE=precompile_placeholder RAILS_ENV=production bundle exec rake assets:precompile
