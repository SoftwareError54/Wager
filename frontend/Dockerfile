FROM node:20-alpine

WORKDIR /app

RUN npm install -g expo-cli

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 19006
EXPOSE 8081

CMD ["npx", "expo", "start", "--web", "--port", "19006"]
CMD ["npx", "expo", "start", "--web", "--port", "19006"]
