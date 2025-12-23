FROM node:20-alpine@sha256:643e7036aa985317ebfee460005e322aa550c6b6883000d01daefb58689a58e2 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --legacy-peer-deps
COPY . .
RUN npm run build

FROM node:20-alpine@sha256:643e7036aa985317ebfee460005e322aa550c6b6883000d01daefb58689a58e2
RUN apk add --no-cache curl
RUN addgroup -S app && adduser -S app -G app
WORKDIR /app
RUN chown -R app:app /app
COPY --chown=app:app package*.json ./
USER app
RUN npm ci --only=production --legacy-peer-deps
COPY --chown=app:app --from=builder /app/dist ./dist
COPY --chown=app:app --from=builder /app/server ./server
COPY --chown=app:app --from=builder /app/src ./src
COPY --chown=app:app --from=builder /app/db ./db
EXPOSE 3001

HEALTHCHECK CMD curl -f http://localhost:3001/health || exit 1

CMD ["node", "server/server.js"]


#test pipeline