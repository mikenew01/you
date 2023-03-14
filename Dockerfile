FROM node:18-alpine As production
WORKDIR /app
COPY . .
RUN npm ci
RUN npm build
EXPOSE 3000
CMD [ "node", "dist/main.js" ]