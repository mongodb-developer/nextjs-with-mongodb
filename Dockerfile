# Get NPM packages
FROM node:16-alpine AS builder
RUN apk add --no-cache libc6-compat

WORKDIR /app
COPY package.json package-lock.json ./
COPY . .

RUN npm ci --only=production && npm run build

# Production image, copy all the files and run next
FROM node:16-alpine AS runner
WORKDIR /app
ENV NODE_ENV production

RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -u 1001
COPY --from=builder --chown=nextjs:nodejs /app .

USER nextjs
EXPOSE 3000

CMD ["npm", "start"]
