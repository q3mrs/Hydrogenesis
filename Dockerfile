FROM node:22-alpine
WORKDIR /app

RUN apk update && \
    apk add python3 py3-pip alpine-sdk openssl-dev build-base python3-dev

COPY package*.json pnpm-lock.yaml* ./
RUN npm i -g pnpm && pnpm install

COPY . .

# this line is required because your build process (astro) reads this file
RUN cp config.example.toml config.toml

RUN pnpm run build

EXPOSE 8080
ENTRYPOINT ["pnpm"]
CMD ["start", "--color"]
