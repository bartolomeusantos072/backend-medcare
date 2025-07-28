FROM node:18

# 1. Define o diretório de trabalho
WORKDIR /usr/src/app

# 2. Copia apenas o que precisa no início (para usar cache de camadas)
COPY package*.json /
COPY .env /.env
COPY . .

# 3. Instala dependências antes de copiar o código-fonte
RUN npm install


# 4. Expõe a porta usada pelo app
EXPOSE 3001

# 5. Usa o script "start" para produção (use "dev" se for para desenvolvimento)
CMD ["npm", "start"]
