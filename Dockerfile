# Stage 1: Python setup for node-gyp
FROM python:3.11 AS python-builder
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN python3 -m venv venv
ENV PATH="/app/venv/bin:$PATH"
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Stage 2: Node setup and dependency installation
FROM node:lts-slim AS deps
WORKDIR /app

# Copy Python setup from previous stage
COPY --from=python-builder /app/venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

RUN apt update || : && apt install -y \
    python3 \
    build-essential \
    python3-dev

RUN apt install g++ make
RUN npm install --global npm@latest
RUN npm install --global node-gyp@latest
RUN npm set registry https://registry.npmjs.org/
RUN npm install --arch=arm64 --target_arch=arm64 node-calls-python

# Install dependencies based on the preferred package manager
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm i -d node-gyp && npm ci -d; \
  elif [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi

# Stage 3: Build application
FROM node:lts-slim AS builder
WORKDIR /app
COPY . .

# Configure npm to retry on network failure
RUN npm set fetch-retries 5
RUN npm set fetch-retry-mintimeout 20000
RUN npm set fetch-retry-maxtimeout 120000

# Build the application
RUN apt update -y && apt install -y openssl
RUN apt install -y \
    python3 \
    build-essential \
    python3-dev

RUN npm ci -d
RUN npx prisma generate

RUN \
  if [ -f yarn.lock ]; then yarn run build; \
  elif [ -f package-lock.json ]; then npm run build; \
  elif [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm run build; \
  else echo "Lockfile not found." && exit 1; \
  fi

# Stage 4: Create final production image
FROM node:lts-slim AS runner
WORKDIR /app

ENV NODE_ENV=production

# Add non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy build artifacts
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=python-builder /app/requirements.txt /app/requirements.txt
COPY --from=python-builder /app/venv /app/venv
COPY --from=builder /app/prisma /app/prisma
COPY --from=builder /app/crew_ai.py /crew_ai.py
COPY --from=builder /app/crew_ai.py /app/crew_ai.py

RUN apt update -y && apt install -y openssl
RUN apt install -y \
    python3 \
    build-essential \
    python3-dev

EXPOSE 3000
ENV PORT=3000

CMD ["npm", "start"]
