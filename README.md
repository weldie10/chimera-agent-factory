# Project Chimera: The Agentic Infrastructure Challenge

> **Role**: Forward Deployed Engineer (FDE) Trainee  
> **Mission**: Architect the "Factory" that builds the "Autonomous Influencer."

## Overview

Project Chimera represents a pivot to building **Autonomous AI Influencers**—digital entities that research trends, generate content, and manage engagement without human intervention.

This repository is architected using **Spec-Driven Development (SDD)** principles, where Intent (Specs) is the source of truth, and Infrastructure (CI/CD, Tests, Docker) ensures reliability.

## Core Philosophies

### Spec-Driven Development (SDD)
- **We do not write implementation code until the Specification is ratified.**
- We use the GitHub Spec Kit framework.
- Ambiguity is the enemy of AI. If your spec is vague, the Agent will hallucinate.

### Traceability (MCP)
- Requirement: Keep the Tenx MCP Sense server connected to your IDE at all times.
- This is your "Black Box" flight recorder.

### Agentic "Skills" vs. "Tools"
- **Skills**: Reusable functions/scripts your agent calls (e.g., `download_video`)
- **MCP Servers**: External bridges (e.g., Database connector)

### Git Hygiene
- Commit early, commit often (Minimum 2x/day).
- Your commit history should tell a story of evolving complexity.

## Repository Structure

```
chimera-agent-factory/
├── specs/              # GitHub Spec Kit structure
│   ├── _meta.md       # High-level vision and constraints
│   ├── functional.md  # User stories and functional requirements
│   ├── technical.md   # API contracts, database schema, technical specs
│   └── openclaw_integration.md  # OpenClaw network integration plan
├── research/          # Architecture and strategy documents
│   ├── architecture_strategy.md
│   └── tooling_strategy.md
├── skills/            # Agent runtime skills (capability packages)
│   ├── README.md
│   └── [skill modules]
├── tests/             # Test-Driven Development (TDD) tests
│   ├── test_trend_fetcher.py
│   └── test_skills_interface.py
├── src/               # Source code (to be implemented)
├── .github/
│   └── workflows/     # CI/CD pipelines
├── .cursor/           # Cursor IDE rules and context
├── Dockerfile         # Containerization
├── Makefile          # Standardized commands
└── pyproject.toml    # Python project configuration
```

## Quick Start

### Prerequisites
- Python 3.11+
- Docker (for containerized testing)
- Git
- Tenx MCP Sense server connected to IDE

### Setup

```bash
# Install dependencies
make setup

# Run tests (should fail initially - TDD approach)
make test

# Check spec alignment
make spec-check
```

## Development Workflow

1. **Read the Specs First**: Always check `specs/` before writing code
2. **Write Failing Tests**: Define the expected behavior in tests
3. **Implement**: Write code to make tests pass
4. **Verify**: Run `make test` and `make spec-check`

## Key Commands

- `make setup` - Install dependencies
- `make test` - Run tests in Docker
- `make spec-check` - Verify code aligns with specs
- `make lint` - Run linters
- `make format` - Format code

## Project Status - Day 1 (February 4, 2025)

✅ **Day 1 Deliverables Complete**:
- Research summary and analysis (`research/research_summary.md`)
- Architecture strategy document (`research/architecture_strategy.md`)
- Master specifications (`specs/`)
- Context engineering (`.cursor/rules`, `CLAUDE.md`)
- Tooling strategy (`research/tooling_strategy.md`)
- Skills structure (`skills/`)
- TDD test framework (`tests/`)
- Infrastructure setup (Dockerfile, Makefile, CI/CD)

🚧 **Next Steps (Day 2-3)**:
- Implement skills following TDD
- Connect OpenClaw MCP server
- Complete agent orchestration
- Full system integration

## License

MIT

## Contributing

This project follows Spec-Driven Development. All contributions must:
1. Align with specifications in `specs/`
2. Include tests
3. Pass CI/CD pipeline
4. Maintain traceability via MCP Sense
