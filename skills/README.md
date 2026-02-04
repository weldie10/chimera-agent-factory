# Chimera Agent Skills

## Overview

Skills are reusable capability packages that Chimera agents use during execution. Each skill is a self-contained module with defined input/output contracts.

## Skill Architecture

```
skills/
├── README.md                    # This file
├── __init__.py                  # Skill registry
├── base.py                      # Base skill classes and interfaces
├── skill_fetch_trends/          # Individual skill modules
│   ├── __init__.py
│   ├── skill.py                # Skill implementation
│   ├── schema.py                # Input/output Pydantic schemas
│   └── tests.py                 # Skill-specific unit tests
├── skill_download_video/
│   ├── __init__.py
│   ├── skill.py
│   ├── schema.py
│   └── tests.py
├── skill_transcribe_audio/
│   └── ...
├── skill_generate_video/
│   └── ...
├── skill_publish_content/
│   └── ...
└── skill_openclaw_announce/
    └── ...
```

## Skill Interface Standard

All skills must implement the `BaseSkill` interface:

```python
from skills.base import BaseSkill, SkillInput, SkillOutput

class MySkillInput(SkillInput):
    """Input schema for the skill"""
    field1: str
    field2: int = 10

class MySkillOutput(SkillOutput):
    """Output schema for the skill"""
    result: dict
    metadata: dict

class SkillMySkill(BaseSkill):
    """Description of what this skill does"""
    
    name = "skill_my_skill"
    version = "0.1.0"
    description = "Detailed description"
    
    async def execute(self, input_data: MySkillInput) -> MySkillOutput:
        """Execute the skill"""
        # Implementation here
        pass
```

## Critical Skills

### 1. `skill_fetch_trends`

**Purpose**: Fetch trending topics from social platforms

**Input Contract**:
```python
class FetchTrendsInput(SkillInput):
    platforms: list[str]  # ["youtube", "tiktok", "twitter"]
    categories: list[str] = []  # Optional filtering
    time_range: str = "24h"  # "24h" | "7d" | "30d"
    max_results: int = 50
```

**Output Contract**:
```python
class FetchTrendsOutput(SkillOutput):
    trends: list[TrendData]
    metadata: dict
    # success and error inherited from SkillOutput
```

**MCP Dependencies**:
- Platform-specific MCP servers (YouTube, TikTok, Twitter)

**Status**: 🚧 Specification Complete, Implementation Pending

---

### 2. `skill_download_video`

**Purpose**: Download videos from social platforms

**Input Contract**:
```python
class DownloadVideoInput(SkillInput):
    source_url: str  # Required
    platform: str  # "youtube" | "tiktok" | "twitter"
    quality: str = "medium"  # "high" | "medium" | "low"
```

**Output Contract**:
```python
class DownloadVideoOutput(SkillOutput):
    local_path: str | None  # If success
    metadata: VideoMetadata | None
    # success and error inherited from SkillOutput
```

**MCP Dependencies**:
- Platform-specific download MCP servers

**Status**: 🚧 Specification Complete, Implementation Pending

---

### 3. `skill_transcribe_audio`

**Purpose**: Transcribe audio from video files

**Input Contract**:
```python
class TranscribeAudioInput(SkillInput):
    video_path: str  # Required
    language: str | None = None  # Auto-detect if None
    include_timestamps: bool = True
```

**Output Contract**:
```python
class TranscribeAudioOutput(SkillOutput):
    transcript: str
    segments: list[TranscriptSegment]
    language: str  # Detected language
    # success and error inherited from SkillOutput
```

**MCP Dependencies**:
- Transcription service MCP (e.g., OpenAI Whisper MCP)

**Status**: 🚧 Specification Complete, Implementation Pending

---

### 4. `skill_generate_video`

**Purpose**: Generate video content from script and assets

**Input Contract**:
```python
class GenerateVideoInput(SkillInput):
    script: str  # Required
    style: str  # Required
    duration: float | None = None  # Seconds
    platform: str  # "youtube" | "tiktok" | "instagram"
    assets: VideoAssets
```

**Output Contract**:
```python
class GenerateVideoOutput(SkillOutput):
    video_path: str | None  # If success
    metadata: VideoMetadata | None
    # success and error inherited from SkillOutput
```

**MCP Dependencies**:
- Video generation service MCP

**Status**: 🚧 Specification Complete, Implementation Pending

---

### 5. `skill_publish_content`

**Purpose**: Publish content to social platforms

**Input Contract**:
```python
class PublishContentInput(SkillInput):
    content_path: str  # Required
    platform: str  # "youtube" | "tiktok" | "instagram" | "twitter"
    title: str  # Required
    description: str | None = None
    tags: list[str] = []
    schedule_time: str | None = None  # ISO8601 datetime
```

**Output Contract**:
```python
class PublishContentOutput(SkillOutput):
    post_id: str | None  # If success
    url: str | None  # If success
    published_at: str | None  # ISO8601 datetime
    # success and error inherited from SkillOutput
```

**MCP Dependencies**:
- Platform-specific publishing MCP servers

**Status**: 🚧 Specification Complete, Implementation Pending

---

### 6. `skill_openclaw_announce`

**Purpose**: Announce agent capabilities to OpenClaw network

**Input Contract**:
```python
class OpenClawAnnounceInput(SkillInput):
    agent_id: str
    capabilities: list[Capability]
    status: str  # "available" | "busy" | "offline"
```

**Output Contract**:
```python
class OpenClawAnnounceOutput(SkillOutput):
    announcement_id: str | None
    timestamp: str  # ISO8601
    # success and error inherited from SkillOutput
```

**MCP Dependencies**:
- OpenClaw MCP server

**Status**: 🚧 Specification Complete, Implementation Pending

---

## Skill Development Guidelines

### 1. Spec Alignment
- Skills must align with `specs/functional.md` and `specs/technical.md`
- Input/output contracts must match API specifications exactly

### 2. Error Handling
- All skills return `SkillOutput` with `success: bool` and `error: str | None`
- Never raise exceptions; return error in output
- Log errors via MCP Sense

### 3. Async by Default
- All skills are async functions
- Use `async/await` for I/O operations
- Support concurrent execution

### 4. Input Validation
- Use Pydantic models for input validation
- Validate all inputs before processing
- Return clear error messages for invalid inputs

### 5. Logging
- Log all skill executions via MCP Sense
- Include: skill name, input (sanitized), output, execution time
- Never log sensitive data (API keys, passwords)

### 6. Testing
- Each skill has unit tests in `skills/{skill_name}/tests.py`
- Tests verify input/output contracts
- Tests mock MCP server dependencies

## Skill Registry

Skills are registered in `skills/__init__.py`:

```python
from skills.skill_fetch_trends import SkillFetchTrends
from skills.skill_download_video import SkillDownloadVideo
# ... etc

SKILL_REGISTRY = {
    "skill_fetch_trends": SkillFetchTrends,
    "skill_download_video": SkillDownloadVideo,
    # ... etc
}
```

## Usage Example

```python
from skills import SKILL_REGISTRY
from skills.skill_fetch_trends.schema import FetchTrendsInput

# Get skill instance
skill_class = SKILL_REGISTRY["skill_fetch_trends"]
skill = skill_class()

# Prepare input
input_data = FetchTrendsInput(
    platforms=["youtube", "tiktok"],
    time_range="24h",
    max_results=50
)

# Execute skill
output = await skill.execute(input_data)

if output.success:
    print(f"Fetched {len(output.trends)} trends")
else:
    print(f"Error: {output.error}")
```

## Next Steps

1. ✅ Define skill interfaces and contracts (DONE)
2. 🚧 Implement base skill classes (`skills/base.py`)
3. 🚧 Implement individual skills (one at a time, following TDD)
4. 🚧 Write tests for each skill
5. 🚧 Integrate skills with agents

---

**Status**: 🚧 Specification Complete, Implementation Pending  
**Last Updated**: 2025-02-04  
**Owner**: FDE Trainee Team
