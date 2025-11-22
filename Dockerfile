# Build stage
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json
COPY package.json ./

# Install dependencies (production only)
RUN npm install --omit=dev --no-package-lock && \
    npm cache clean --force

# Copy application files
COPY app.js ./

# Production stage
FROM node:18-alpine AS production


# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Set working directory
WORKDIR /app

# Copy dependencies and app from builder stage
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --chown=nodejs:nodejs app.js ./
COPY --chown=nodejs:nodejs package.json ./

# Switch to non-root user
USER nodejs

# Expose port
EXPOSE 3000


# Start application
CMD ["node", "app.js"]
