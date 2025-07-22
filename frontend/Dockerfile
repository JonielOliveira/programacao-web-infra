FROM node:20

WORKDIR /app/frontend
COPY . .
RUN npm install && npm run build

CMD ["npm", "start"]
