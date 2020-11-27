FROM node:12 as base

WORKDIR /app
RUN apk add

COPY package.json ./

# Dependencies
FROM base as dependencies

RUN apt-get install -y bluez bluetooth

# Release
FROM base as release

COPY --from=dependencies /app/node_modules ./node_modules


COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["npm", "start"]
