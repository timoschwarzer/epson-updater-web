FROM node:alpine

WORKDIR /app
COPY . /app

RUN yarn install --no-dev && \
    apk add --no-cache curl coreutils

ENTRYPOINT ["node", "/app/src/index.js"]
