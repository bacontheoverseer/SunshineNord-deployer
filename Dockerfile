FROM node:lts-alpine

LABEL maintainer="TitaniumNetwork Ultraviolet Team"
LABEL summary="Ultraviolet Proxy Image"
LABEL description="Example application of Ultraviolet which can be deployed in production."

ENV NODE_ENV=production
WORKDIR /app

# 1. Install building tools required for native proxy extensions
RUN apk add --upgrade --no-cache python3 make g++

# 2. Install pnpm globally
RUN npm install --global pnpm

# 3. Copy ALL workspace configuration files first
COPY package.json pnpm-lock.yaml *pnpm-workspace.yaml ./

# 4. Force pnpm to hoist and link all dependencies flatly into /app/node_modules
RUN pnpm config set shamefully-hoist true && \
    pnpm install --prod --no-frozen-lockfile

# 5. Copy over the rest of the application files
COPY . .

# NOTE: The "RUN rm -rf" line has been completely removed so your 
# @mercuryworkshop modules stay installed safely!

EXPOSE 8080

ENTRYPOINT [ "node" ]
CMD ["src/index.js"]
