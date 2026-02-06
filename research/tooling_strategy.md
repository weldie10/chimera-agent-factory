# Project Chimera - Tooling Strategy

## Overview

This document defines the tooling strategy for Project Chimera, distinguishing between **Developer Tools (MCP)** and **Agent Skills (Runtime)**.

## Tooling Philosophy

### Two Categories of Tools

1. **Developer Tools (MCP)**: Tools that help **developers** build and maintain the system
2. **Agent Skills (Runtime)**: Tools that **agents** use during execution

### Why This Distinction Matters

- **Separation of Concerns**: Development tools shouldn't be in production runtime
- **Security**: Limit agent access to only necessary capabilities
- **Maintainability**: Clear boundaries make the system easier to understand and modify

## Developer Tools (MCP Servers)

### Purpose

MCP servers that assist in development, testing, and maintenance of the Chimera system.

### Selected MCP Servers

#### 1. Git MCP Server
**Purpose**: Version control operations  
**Use Cases**:
- Commit code changes
- Create branches
- View commit history
- Generate changelogs

**Configuration**:
```json
{
  "mcpServers": {
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git"],
      "env": {
        "GIT_REPO_PATH": "${PROJECT_ROOT}"
      }
    }
  }
}
```

#### 2. Filesystem MCP Server
**Purpose**: File operations during development  
**Use Cases**:
- Read/write project files
- Create directory structures
- Search files by pattern
- File metadata operations

**Configuration**:
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": [
          "${PROJECT_ROOT}"
        ]
      }
    }
  }
}
```

#### 3. PostgreSQL MCP Server
**Purpose**: Database development and testing  
**Use Cases**:
- Run SQL queries during development
- Inspect database schema
- Test database migrations
- Seed test data

**Configuration**:
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:pass@localhost:5432/chimera"
      }
    }
  }
}
```

#### 4. Tenx MCP Sense Server
**Purpose**: Telemetry and traceability (MANDATORY)  
**Use Cases**:
- Log all agent actions
- Track code changes
- Monitor system behavior
- Audit trail

**Configuration**:
```json
{
  "mcpServers": {
    "tenx-sense": {
      "command": "npx",
      "args": ["-y", "@tenx/mcp-sense"],
      "env": {
        "TENX_API_KEY": "${TENX_API_KEY}",
        "GITHUB_USERNAME": "${GITHUB_USERNAME}"
      }
    }
  }
}
```

**⚠️ CRITICAL**: This server must be connected at all times during development.

### Developer Tool Usage Guidelines

1. **Development Only**: These MCP servers are for development, not production runtime
2. **IDE Integration**: Configured in `.cursor/mcp.json` or IDE settings
3. **Security**: Never commit API keys or credentials to repository

## Agent Skills (Runtime)

### Purpose

Reusable capability packages that agents call during execution. Skills are Python modules that implement standardized interfaces.

### Skill Architecture

```
skills/
├── README.md                    # Skills documentation
├── __init__.py                  # Skill registry
├── base.py                      # Base skill classes
├── skill_fetch_trends/          # Individual skill modules
│   ├── __init__.py
│   ├── skill.py                # Skill implementation
│   ├── schema.py                # Input/output schemas
│   └── tests.py                 # Skill-specific tests
├── skill_download_video/
│   └── ...
├── skill_transcribe_audio/
│   └── ...
└── skill_generate_video/
    └── ...
```

### Skill Interface Standard

All skills must implement:

```python
from typing import Dict, Any
from pydantic import BaseModel
from skills.base import BaseSkill, SkillInput, SkillOutput

class FetchTrendsInput(SkillInput):
    platforms: list[str]
    time_range: str = "24h"
    max_results: int = 50

class FetchTrendsOutput(SkillOutput):
    trends: list[Dict[str, Any]]
    metadata: Dict[str, Any]

class SkillFetchTrends(BaseSkill):
    """Fetches trending topics from social platforms"""
    
    name = "skill_fetch_trends"
    version = "0.1.0"
    
    async def execute(self, input_data: FetchTrendsInput) -> FetchTrendsOutput:
        """Execute the skill"""
        # Implementation
        pass
```

### Critical Skills (Initial Implementation)

#### 1. `skill_fetch_trends`
**Purpose**: Fetch trending topics from social platforms  
**Input**: Platforms, time range, max results  
**Output**: Normalized trend data  
**MCP Dependencies**: Platform-specific MCP servers (YouTube, TikTok, Twitter)

#### 2. `skill_download_video`
**Purpose**: Download videos from social platforms  
**Input**: Source URL, platform, quality  
**Output**: Local file path, metadata  
**MCP Dependencies**: Platform-specific MCP servers

#### 3. `skill_transcribe_audio`
**Purpose**: Transcribe audio from video files  
**Input**: Video path, language, timestamps flag  
**Output**: Transcript with segments  
**MCP Dependencies**: Transcription service MCP (e.g., OpenAI Whisper MCP)

#### 4. `skill_generate_video`
**Purpose**: Generate video content from script and assets  
**Input**: Script, style, platform, assets  
**Output**: Generated video path and metadata  
**MCP Dependencies**: Video generation service MCP

#### 5. `skill_publish_content`
**Purpose**: Publish content to social platforms  
**Input**: Content path, platform, metadata  
**Output**: Post ID, URL, publish timestamp  
**MCP Dependencies**: Platform-specific publishing MCP servers

#### 6. `skill_openclaw_announce`
**Purpose**: Announce agent capabilities to OpenClaw network  
**Input**: Capabilities list, status  
**Output**: Announcement confirmation  
**MCP Dependencies**: OpenClaw MCP server

### Skill Development Guidelines

1. **Spec-First**: Skills must align with `specs/functional.md` and `specs/technical.md`
2. **Input/Output Contracts**: All skills use Pydantic models for validation
3. **Error Handling**: Skills return `SkillOutput` with success/error status
4. **Async by Default**: All skills are async functions
5. **Logging**: All skill executions logged via MCP Sense
6. **Testing**: Each skill has corresponding tests in `tests/`

## MCP Server Strategy for Agents

### Runtime MCP Servers

These MCP servers are used by agents during execution:

1. **Database MCP**: PostgreSQL operations for storing trends, content, publications
2. **Platform MCPs**: YouTube, TikTok, Twitter, Instagram APIs
3. **OpenClaw MCP**: Agent social network communication
4. **Storage MCP**: File storage operations (S3, local filesystem)
5. **Transcription MCP**: Audio transcription services

### MCP vs Direct API Calls

**Decision**: Use MCP servers for all external integrations

**Rationale**:
- **Consistency**: Uniform interface for all external services
- **Testability**: Can mock MCP servers for testing
- **Security**: Centralized authentication and rate limiting
- **Observability**: All external calls logged via MCP

## Tooling Configuration

### Development Environment

**File**: `.cursor/mcp.json` (or IDE-specific config)

```json
{
  "mcpServers": {
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"]
    },
    "tenx-sense": {
      "command": "npx",
      "args": ["-y", "@tenx/mcp-sense"]
    }
  }
}
```

### Runtime Environment

**File**: `config/mcp_servers.json` (for agent runtime)

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${DATABASE_URL}"
      }
    },
    "openclaw": {
      "command": "npx",
      "args": ["-y", "@openclaw/mcp-server"],
      "env": {
        "OPENCLAW_API_KEY": "${OPENCLAW_API_KEY}"
      }
    }
  }
}
```

## Testing Strategy for Tools

### Developer Tools Testing

- **Manual Testing**: Verify MCP servers work in IDE
- **Integration Testing**: Test MCP server connectivity
- **Documentation**: Document MCP server setup in README

### Agent Skills Testing

- **Unit Tests**: Test skill logic in isolation
- **Integration Tests**: Test skills with mocked MCP servers
- **Contract Tests**: Verify input/output schemas
- **E2E Tests**: Test full skill execution flow

## Security Considerations

### Developer Tools

- **API Keys**: Stored in environment variables, never committed
- **Access Control**: Limit filesystem MCP to project directory only
- **Audit**: All MCP operations logged

### Agent Skills

- **Input Validation**: All inputs validated via Pydantic
- **Output Sanitization**: Sanitize outputs before returning
- **Rate Limiting**: Skills respect platform rate limits
- **Error Handling**: Never expose sensitive information in errors

## Future Enhancements

1. **Skill Marketplace**: Share skills across projects
2. **Skill Versioning**: Version skills for backward compatibility
3. **Skill Composition**: Combine skills into workflows
4. **Performance Monitoring**: Track skill execution metrics

---

## Summary

### Developer Tools (MCP) - ✅ Complete
- Git MCP Server: Version control operations
- Filesystem MCP Server: File operations during development
- PostgreSQL MCP Server: Database development and testing
- Tenx MCP Sense Server: Telemetry and traceability (MANDATORY)

### Agent Skills (Runtime) - ✅ Complete
- 6 critical skills defined with Input/Output contracts
- Skill architecture structure ready
- Base classes implemented (`skills/base.py`)
- All contracts reference `specs/technical.md` for complete Pydantic models

---

**Status**: ✅ Complete  
**Last Updated**: 2026-02-05  
**Author**: Weldeyohans Nigus
