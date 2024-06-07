FROM node:16-alpine

WORKDIR /app

ENV NODE_ENV="production"

COPY . .

RUN npm ci && addgroup -S app && adduser -S app -G app && chown -R app:app . 

USER app

EXPOSE 8080

CMD ["npm", "run", "start"]