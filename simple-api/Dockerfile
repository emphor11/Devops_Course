# Stage 1: Builder
FROM node:18 AS builder
WORKDIR /app

# Copy package files first to leverage Docker caching
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app

# Install curl for the healthcheck
RUN apk add --no-cache curl

# Copy built application from the builder stage
COPY --from=builder /app .

# Create a non-root user for security
RUN adduser -D appuser
USER appuser

# Expose the API port
EXPOSE 3000

# Add the healthcheck
HEALTHCHECK CMD curl --fail http://localhost:3000/health || exit 1

# Command to run the application (index.js instead of app.js)
CMD ["node", "index.js"]
