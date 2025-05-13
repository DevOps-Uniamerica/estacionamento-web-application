# Etapa 1: Build do Vue.js
FROM node:18-alpine AS build

WORKDIR /app

# Copia os arquivos de dependências
COPY package*.json ./

# Instala as dependências do projeto
RUN npm install --force

# Copia o restante do código-fonte
COPY . .

# Gera o build de produção
RUN npm run build

# Etapa 2: Servir os arquivos com Nginx
FROM nginx:alpine

# Copia os arquivos gerados pelo build para o diretório do Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Expõe a porta 80
EXPOSE 80

# Comando para iniciar o Nginx
CMD ["nginx", "-g", "daemon off;"]
