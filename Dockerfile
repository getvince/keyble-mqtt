FROM node:12 as base

WORKDIR /app
RUN apk add

COPY package.json ./

# Dependencies
FROM base as dependencies

RUN apk add --no-cache --virtual .buildtools make gcc g++ python3 linux-headers git && \
    npm ci --production && \
    apk del .buildtools

# Release
FROM base as release

COPY --from=dependencies /app/node_modules ./node_modules


COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir /app/data

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["npm", "start"]
