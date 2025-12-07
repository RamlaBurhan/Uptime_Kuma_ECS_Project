ARG APP_VERSION=1.0.0

FROM node:20-alpine:sha256:643e7036aa985317ebfee460005e322aa550c6b6883000d01daefb58689a58e2

LABEL version="${APP_VERSION}"

WORKDIR /app

COPY package*.json ./

RUN npm install --legacy-peer-deps 

COPY . .

RUN npm run build

EXPOSE 3001

# tests if server responds on port 3001
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:3001 || exit 1

CMD ["node", "server/server.js"]