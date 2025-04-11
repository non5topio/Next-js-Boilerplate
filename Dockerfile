# ---------------- Base Stage ----------------
    FROM node:20 AS base

    WORKDIR /app
    
    COPY package*.json ./
    RUN npm install
    
    COPY . .
    
    # ---------------- Test Stage ----------------
    FROM base AS test
    
    # Install additional dev dependencies for testing
    RUN npm install -D vitest
    
    # Run tests (with coverage if needed)
    # You can override this in config.json or CLI as well
    CMD npm run test -- --coverage --coverage.reporter=cobertura
    
    # ---------------- Build Stage ----------------
    FROM base AS build
    
    RUN npm run build
    
    # ---------------- Runtime Stage ----------------
    FROM node:20 AS production
    
    WORKDIR /app
    
    # Copy only necessary files from build stage
    COPY --from=build /app ./
    
    EXPOSE 3000
    
    CMD ["npm", "start"]

    #
    