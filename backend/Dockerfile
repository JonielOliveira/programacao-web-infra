FROM node:20

WORKDIR /app/backend
COPY . .
RUN npm install && npm run build

CMD ["npm", "start"]
