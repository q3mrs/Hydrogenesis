FROM node:22-alpine
WORKDIR /app

# remove --no-network so we can download the build tools
RUN apk update && \
    apk add --no-cache python3 py3-pip alpine-sdk openssl-dev build-base python3-dev

COPY package*.json pnpm-lock.yaml* ./
RUN npm i -g pnpm && pnpm install

# force rebuild of sqlite3 inside the alpine container
RUN pnpm rebuild sqlite3

COPY . .

# checking if our "stolen" files are in the right spot
RUN ls -la /app/workerware_new/src

RUN cp config.example.toml config.toml
RUN pnpm run build

EXPOSE 8080
ENTRYPOINT ["pnpm"]
CMD ["start", "--color"]
