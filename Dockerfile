FROM node:22-alpine
WORKDIR /app

# we need these extra tools to compile sqlite3 from source
RUN apk update && \
    apk add --no-network --no-cache python3 py3-pip alpine-sdk openssl-dev build-base python3-dev

COPY package*.json pnpm-lock.yaml* ./
RUN npm i -g pnpm && pnpm install

# --- ADD THIS LINE HERE ---
# this fixes the "bindings.js" and "node_sqlite3.node" error
RUN pnpm rebuild sqlite3

COPY . .

# verify your workerware files are still there
RUN ls -la /app/workerware_new/src

RUN cp config.example.toml config.toml
RUN pnpm run build

EXPOSE 8080
ENTRYPOINT ["pnpm"]
CMD ["start", "--color"]
