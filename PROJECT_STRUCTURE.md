# Project Chimera - Project Structure

## Directory Tree

```
chimera-agent-factory/
├── .cursor/
│   └── rules                    # Cursor IDE rules for AI agents
├── .github/
│   └── workflows/
│       └── main.yml            # CI/CD pipeline
├── research/
│   ├── architecture_strategy.md # Architectural decisions
│   └── tooling_strategy.md      # Tooling strategy (MCP vs Skills)
├── skills/
│   ├── __init__.py              # Skill registry
│   ├── base.py                  # Base skill classes
│   └── README.md                # Skills documentation
├── specs/
│   ├── _meta.md                 # High-level vision and constraints
│   ├── functional.md            # User stories and functional requirements
│   ├── technical.md             # API contracts, database schema
│   └── openclaw_integration.md  # OpenClaw network integration
├── src/
│   └── __init__.py              # Source code package (to be implemented)
├── tests/
│   ├── __init__.py
│   ├── test_trend_fetcher.py    # TDD tests for trend fetching
│   └── test_skills_interface.py # TDD tests for skill interface
├── .coderabbit.yaml             # AI code review configuration
├── .gitignore                   # Git ignore patterns
├── CLAUDE.md                    # Context for AI agents (Claude, etc.)
├── Dockerfile                   # Containerization
├── Makefile                     # Standardized commands
├── PROJECT_STRUCTURE.md         # This file
├── pyproject.toml               # Python project configuration
└── README.md                    # Main project documentation
```

## File Purposes

### Core Configuration
- **`pyproject.toml`**: Python project metadata, dependencies, tool configurations
- **`Makefile`**: Standardized commands (`make setup`, `make test`, etc.)
- **`Dockerfile`**: Multi-stage Docker build for containerization
- **`.gitignore`**: Git ignore patterns for Python, IDE, and environment files

### Specifications (Source of Truth)
- **`specs/_meta.md`**: Project vision, principles, constraints, success criteria
- **`specs/functional.md`**: User stories, acceptance criteria, non-functional requirements
- **`specs/technical.md`**: API contracts, database schema, technology stack
- **`specs/openclaw_integration.md`**: OpenClaw protocol specifications

### Research & Architecture
- **`research/architecture_strategy.md`**: Agent patterns, database selection, infrastructure decisions
- **`research/tooling_strategy.md`**: Developer tools (MCP) vs Agent skills distinction

### Skills (Runtime Capabilities)
- **`skills/base.py`**: Base classes (`BaseSkill`, `SkillInput`, `SkillOutput`)
- **`skills/__init__.py`**: Skill registry (populated as skills are implemented)
- **`skills/README.md`**: Skill development guidelines and interface standards

### Tests (TDD)
- **`tests/test_trend_fetcher.py`**: Tests for trend fetching (should fail initially)
- **`tests/test_skills_interface.py`**: Tests for skill interface compliance

### CI/CD & Governance
- **`.github/workflows/main.yml`**: GitHub Actions pipeline (lint, test, build)
- **`.coderabbit.yaml`**: AI code review policies (spec alignment, security, quality)

### AI Agent Context
- **`.cursor/rules`**: Cursor IDE rules for AI agents
- **`CLAUDE.md`**: Context document for Claude and other AI assistants

## Next Steps

1. ✅ **Project skeleton created** (DONE)
2. 🚧 **Connect Tenx MCP Sense** to IDE (REQUIRED)
3. 🚧 **Initialize Git repository** and make initial commit
4. 🚧 **Set up Python environment** using `uv` or `pip`
5. 🚧 **Run `make setup`** to install dependencies
6. 🚧 **Run `make test`** to verify failing tests (TDD approach)
7. 🚧 **Begin implementation** following specs and TDD

## Verification Checklist

- [x] All spec files created (`specs/`)
- [x] Research documents created (`research/`)
- [x] Skills structure created (`skills/`)
- [x] Tests created (`tests/`) - should fail initially
- [x] Dockerfile created
- [x] Makefile created
- [x] CI/CD pipeline created (`.github/workflows/`)
- [x] AI review config created (`.coderabbit.yaml`)
- [x] AI context files created (`.cursor/rules`, `CLAUDE.md`)
- [x] Project documentation created (`README.md`)

---

**Status**: ✅ Project Skeleton Complete  
**Last Updated**: 2025-02-04
