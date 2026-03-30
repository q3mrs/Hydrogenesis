FROM node:22-alpine
WORKDIR /app

# 1. install essential build tools
RUN apk add --no-cache python3 make g++ gcc libc-dev sqlite-dev

COPY package*.json pnpm-lock.yaml* ./
RUN npm i -g pnpm && pnpm install

# 2. force rebuild specifically using the container's environment
# we add --build-from-source to ensure it ignores any pre-built windows/linux binaries
RUN pnpm rebuild sqlite3 --build-from-source

COPY . .

# 3. verify your files are in the new path
RUN ls -la /app/workerware_new/src

RUN cp config.example.toml config.toml
RUN pnpm run build

EXPOSE 8080
ENTRYPOINT ["pnpm"]
CMD ["start", "--color"]
