FROM node:22-alpine
WORKDIR /usr/src/app
# 1. install essential build tools
RUN apk add --no-cache python3 make g++ gcc libc-dev sqlite-dev

COPY package*.json pnpm-lock.yaml* ./
RUN npm i -g pnpm && pnpm install --no-frozen-lockfile
# 2. force rebuild specifically using the container's environment
# we add --build-from-source to ensure it ignores any pre-built windows/linux binaries
RUN npm_config_build_from_source=true pnpm rebuild sqlite3
COPY . .

# 3. verify your files are in the new path
RUN ls -la /usr/src/app
RUN cp config.example.toml config.toml
RUN pnpm run build

EXPOSE 8080
ENTRYPOINT ["pnpm"]
CMD ["start", "--color"]
