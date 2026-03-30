FROM node:22-alpine

WORKDIR /app

# install build tools for any native modules
RUN apk update && \
    apk add python3 py3-pip alpine-sdk openssl-dev build-base python3-dev

# install pnpm and dependencies
COPY package*.json pnpm-lock.yaml* ./
RUN npm i -g pnpm && pnpm install

# copy the rest of your code (including your manual public/uv folder)
COPY . .

# run the build - this is where it was failing
RUN pnpm run build

EXPOSE 8080
ENTRYPOINT ["pnpm"]
CMD ["start", "--color"]
