# Etapa de build
FROM node:18 AS build

WORKDIR /usr/src/app

# Copiar arquivos de configuração e instalar dependências
COPY package*.json ./
RUN npm install

# Copiar o restante do código-fonte e rodar o build
COPY . .
RUN npm run build

# Instalar apenas as dependências de produção para a próxima etapa
RUN npm install --omit=dev

# Etapa de produção
FROM node:18-alpine3.19

WORKDIR /usr/src/app

# Copiar arquivos necessários para a produção
COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

# Expõe a porta da aplicação
EXPOSE 3000

# Comando para iniciar o aplicativo
CMD ["npm", "run", "start:prod"]
