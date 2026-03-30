FROM node:22-alpine
WORKDIR /app

# Add git so we can pull the submodule files
RUN apk update && \
    apk add python3 py3-pip alpine-sdk openssl-dev build-base python3-dev git

COPY package*.json pnpm-lock.yaml* ./
RUN npm i -g pnpm && pnpm install

# Copy everything including the .gitmodules file
COPY . .

# CRITICAL: Pull the actual files for workerware
RUN git submodule update --init --recursive

# Now the files exist, so the build won't fail
RUN cp config.example.toml config.toml
RUN pnpm run build

EXPOSE 8080
ENTRYPOINT ["pnpm"]
CMD ["start", "--color"]
