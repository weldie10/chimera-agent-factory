# Project Chimera - Dockerfile
# Multi-stage build for production-ready containerization

FROM python:3.11-slim as builder

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install uv for faster dependency management (optional)
RUN pip install --no-cache-dir uv || echo "uv installation skipped"

# Copy dependency files
COPY pyproject.toml ./

# Install dependencies
RUN if command -v uv >/dev/null 2>&1; then \
        uv pip install --system -e ".[dev]"; \
    else \
        pip install --no-cache-dir -e ".[dev]"; \
    fi

# Production stage
FROM python:3.11-slim

WORKDIR /app

# Install runtime dependencies only
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy project files
COPY . .

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Run tests by default (can be overridden)
CMD ["make", "test"]
