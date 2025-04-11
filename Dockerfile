# Stage 1: Build the application
FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .
RUN yarn build

# Stage 2: Serve the built app
FROM node:18-alpine

WORKDIR /app

# Install a lightweight static file server
RUN yarn global add serve

# Copy the build output from the previous stage
COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["serve", "-s", "dist", "-l", "3000"]
