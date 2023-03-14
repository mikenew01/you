# Stage 1: Build the NestJS app
FROM node:16-alpine as builder

# Create the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

RUN npm install -g @nestjs/cli

# Copy the rest of the app
COPY . .

# Build the app for production
RUN npm run build

# Remove development dependencies
RUN npm prune --production

# Stage 2: Run the NestJS app in production
FROM node:16-alpine

# Set the working directory
WORKDIR /app

# Copy the built app and node_modules from the builder stage
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/node_modules /app/node_modules

# Set the NODE_ENV to production
ENV NODE_ENV=production

# Expose the port the app will run on
EXPOSE 3000

# Start the NestJS app
CMD ["node", "dist/main"]
