FROM node:22-alpine
WORKDIR /app

# 1. install the compilers (no --no-network flag this time)
RUN apk update && \
    apk add --no-cache python3 py3-pip alpine-sdk openssl-dev build-base python3-dev

# 2. setup pnpm and install dependencies
COPY package*.json pnpm-lock.yaml* ./
RUN npm i -g pnpm && pnpm install

# 3. CRITICAL: rebuild sqlite3 now that we actually have the compilers
RUN pnpm rebuild sqlite3

# 4. copy the rest of your files (including workerware_new)
COPY . .

# 5. verify your folder is there for the build step
RUN ls -la /app/workerware_new/src

# 6. standard build steps
RUN cp config.example.toml config.toml
RUN pnpm run build

EXPOSE 8080
ENTRYPOINT ["pnpm"]
CMD ["start", "--color"]
