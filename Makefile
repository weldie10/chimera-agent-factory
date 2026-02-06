.PHONY: setup test lint format spec-check clean docker-build docker-test help

# Default target
.DEFAULT_GOAL := help

# Variables
PYTHON := python3
PIP := pip
DOCKER_IMAGE := chimera-agent-factory
DOCKER_TAG := latest

help: ## Show this help message
	@echo "Project Chimera - Makefile Commands"
	@echo "===================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Install dependencies using uv (or pip if uv not available)
	@echo "Setting up development environment..."
	@if command -v uv >/dev/null 2>&1; then \
		uv pip install -e ".[dev]"; \
	else \
		$(PIP) install -e ".[dev]"; \
	fi
	@echo "✓ Dependencies installed"

test: ## Run tests locally (these should fail initially - TDD approach)
	@echo "Running tests (TDD: tests should fail until implementation)..."
	$(PYTHON) -m pytest tests/ -v
	@echo "✓ Tests completed"

docker-build: ## Build Docker image
	@echo "Building Docker image..."
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	@echo "✓ Docker image built"

docker-test: docker-build ## Run tests in Docker container
	@echo "Running tests in Docker..."
	docker run --rm $(DOCKER_IMAGE):$(DOCKER_TAG) make test
	@echo "✓ Docker tests completed"

lint: ## Run linters (ruff, mypy)
	@echo "Running linters..."
	@if command -v ruff >/dev/null 2>&1; then \
		ruff check src/ tests/; \
	else \
		echo "⚠ ruff not installed, skipping..."; \
	fi
	@if command -v mypy >/dev/null 2>&1; then \
		mypy src/ --ignore-missing-imports || true; \
	else \
		echo "⚠ mypy not installed, skipping..."; \
	fi
	@echo "✓ Linting completed"

format: ## Format code with black and ruff
	@echo "Formatting code..."
	@if command -v black >/dev/null 2>&1; then \
		black src/ tests/; \
	else \
		echo "⚠ black not installed, skipping..."; \
	fi
	@if command -v ruff >/dev/null 2>&1; then \
		ruff check --fix src/ tests/; \
	else \
		echo "⚠ ruff not installed, skipping..."; \
	fi
	@echo "✓ Code formatted"

spec-check: ## Verify code aligns with specifications
	@echo "Checking spec alignment..."
	@echo "Checking if specs/ directory exists..."
	@test -d specs/ || (echo "❌ specs/ directory not found" && exit 1)
	@echo "Checking if required spec files exist..."
	@test -f specs/_meta.md || (echo "❌ specs/_meta.md not found" && exit 1)
	@test -f specs/functional.md || (echo "❌ specs/functional.md not found" && exit 1)
	@test -f specs/technical.md || (echo "❌ specs/technical.md not found" && exit 1)
	@echo "✓ Spec structure validated"
	@echo "⚠ Note: Full spec alignment check requires implementation of spec-check script"

clean: ## Clean build artifacts and cache
	@echo "Cleaning..."
	find . -type d -name __pycache__ -exec rm -r {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	find . -type d -name "*.egg-info" -exec rm -r {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -r {} + 2>/dev/null || true
	find . -type d -name ".coverage" -exec rm -r {} + 2>/dev/null || true
	rm -rf dist/ build/ htmlcov/ .tox/
	@echo "✓ Clean completed"
