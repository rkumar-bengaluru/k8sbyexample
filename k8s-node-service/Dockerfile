FROM node:alpine

WORKDIR /app

EXPOSE 3000

COPY package.json package-lock.json ./

RUN npm install

COPY index.js ./

COPY index.mjs ./

CMD ["npm", "start"]
