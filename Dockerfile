FROM node:22-alpine
WORKDIR /usr/src/app
RUN apk add --no-cache python3 make g++ gcc libc-dev sqlite-dev
COPY package*.json pnpm-lock.yaml* ./
RUN npm i -g pnpm && pnpm install --no-frozen-lockfile
RUN npm_config_build_from_source=true pnpm rebuild sqlite3 --build-from-source
COPY . .
RUN ls -la /usr/src/app
RUN cp config.example.toml config.toml
RUN pnpm run build
EXPOSE 8080
ENTRYPOINT ["pnpm"]
CMD ["start", "--color"]
