# Stage 1 - build
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2 - runtime
FROM node:20-alpine
WORKDIR /app

# Instalar SQLite no container
RUN apk add --no-cache sqlite

COPY --from=build /app/package*.json ./
RUN npm ci --omit=dev
COPY --from=build /app/dist ./dist
COPY --from=build /app/sql ./sql
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "dist/main.js"]
