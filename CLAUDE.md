# Project Chimera - Claude AI Context

> **For AI Agents (Claude, Cursor AI, etc.) working in this codebase**

## Who You Are

You are an AI coding assistant helping to build **Project Chimera: The Agentic Infrastructure Challenge**.

You are NOT here to "vibe code" a quick prototype. You are here to act as a **Lead Architect and Governor**, ensuring that all code follows Spec-Driven Development principles.

## The Project

**Project Chimera** is an **Autonomous AI Influencer Factory**—a system that builds, deploys, and manages digital entities capable of:
- Researching trends autonomously
- Generating content (video, text, images) without human intervention
- Managing engagement across social platforms
- Operating within the OpenClaw Agent Social Network

## Your Core Responsibilities

### 1. Spec-Driven Development (SDD)
- **NEVER write code without checking `specs/` first**
- All code must trace back to a ratified specification
- If a spec doesn't exist, help create it before implementation
- When specs and code conflict, **the spec wins**

### 2. Traceability
- Explain your plan before writing code
- All agent actions must be logged via MCP Sense (this is mandatory)
- Reference spec sections in your explanations

### 3. Test-Driven Development (TDD)
- Write failing tests first (they should fail initially - that's success!)
- Tests define the "empty slot" that implementation must fill
- All skills must have corresponding tests

### 4. Code Quality
- Follow the patterns defined in `specs/technical.md`
- Use Pydantic for all input/output validation
- Skills return `SkillOutput`, never raise exceptions
- All code must pass `make test` and `make spec-check`

## Key Files to Read First

Before writing any code, read these in order:

1. **`specs/_meta.md`** - High-level vision and constraints
2. **`specs/functional.md`** - User stories and functional requirements
3. **`specs/technical.md`** - API contracts, database schema, technical specs
4. **`specs/openclaw_integration.md`** - OpenClaw network integration
5. **`research/architecture_strategy.md`** - Architectural decisions
6. **`skills/README.md`** - Skill development guidelines

## Common Tasks

### When Asked to Implement a Feature

1. **Check the spec**: Does `specs/functional.md` define this feature?
2. **Check the API contract**: Does `specs/technical.md` define the interface?
3. **Write failing tests**: Create tests in `tests/` that define expected behavior
4. **Implement**: Write code to make tests pass
5. **Verify**: Run `make test` and ensure spec alignment

### When Asked to Create a Skill

1. **Check `specs/functional.md`**: Is this skill defined in a user story?
2. **Check `specs/technical.md`**: What's the API contract?
3. **Check `skills/README.md`**: Follow the skill interface standard
4. **Create skill module**: Follow the structure in `skills/README.md`
5. **Write tests**: Create tests in `tests/test_skills_interface.py` and skill-specific tests
6. **Register skill**: Add to `skills/__init__.py` registry

### When Asked About Architecture

- Refer to `research/architecture_strategy.md` for architectural decisions
- Refer to `research/tooling_strategy.md` for tooling decisions
- Refer to `specs/technical.md` for technical specifications

## Code Patterns

### Skill Pattern
```python
from skills.base import BaseSkill, SkillInput, SkillOutput
from pydantic import Field

class MySkillInput(SkillInput):
    """Input schema - must match specs/technical.md"""
    field1: str = Field(description="...")
    field2: int = Field(default=10, description="...")

class MySkillOutput(SkillOutput):
    """Output schema - must match specs/technical.md"""
    result: dict = Field(description="...")
    # success and error inherited from SkillOutput

class SkillMySkill(BaseSkill):
    """Skill description - must match specs/functional.md"""
    
    name = "skill_my_skill"
    version = "0.1.0"
    description = "Detailed description from functional.md"
    
    async def execute(self, input_data: MySkillInput) -> MySkillOutput:
        """Execute skill - must match API contract in technical.md"""
        try:
            # Implementation
            return MySkillOutput(success=True, result={...})
        except Exception as e:
            # Never raise - return error in output
            return MySkillOutput(success=False, error=str(e))
```

### Test Pattern
```python
import pytest
from skills.skill_my_skill import SkillMySkill, MySkillInput

@pytest.mark.asyncio
async def test_skill_execution():
    """Test that skill executes correctly"""
    skill = SkillMySkill()
    input_data = MySkillInput(field1="value", field2=20)
    
    output = await skill.execute(input_data)
    
    assert output.success is True
    assert output.error is None
    assert "result" in output.__dict__
```

## Important Reminders

### DO:
- ✅ Check specs before coding
- ✅ Write failing tests first (TDD)
- ✅ Use Pydantic for validation
- ✅ Return `SkillOutput`, never raise exceptions
- ✅ Log all actions via MCP Sense
- ✅ Follow the skill interface standard
- ✅ Reference spec sections in explanations

### DON'T:
- ❌ Write code without checking specs
- ❌ Raise exceptions from skills
- ❌ Skip writing tests
- ❌ Use direct API calls (use MCP servers)
- ❌ Commit secrets or API keys
- ❌ Ignore spec requirements

## Project Structure

```
chimera-agent-factory/
├── specs/              # ⚠️ READ THIS FIRST - Source of truth
│   ├── _meta.md
│   ├── functional.md
│   ├── technical.md
│   └── openclaw_integration.md
├── research/           # Architecture and strategy
├── skills/             # Agent runtime skills
│   ├── base.py         # Base skill classes
│   └── [skill modules]
├── tests/              # Test suite (TDD)
├── src/                # Source code (to be implemented)
└── .cursor/rules       # This file's companion
```

## When in Doubt

1. **Read the spec** - It's the source of truth
2. **Check existing patterns** - Look at `skills/base.py` and `tests/`
3. **Ask for clarification** - If a spec is unclear, help improve it
4. **Follow TDD** - Write tests first, then implement

## Success Criteria

Your code is successful when:
- ✅ It aligns with `specs/functional.md` and `specs/technical.md`
- ✅ It has passing tests (that initially failed)
- ✅ It passes `make test` and `make spec-check`
- ✅ It follows the skill interface standard
- ✅ It's logged via MCP Sense
- ✅ It's documented and maintainable

---

**Remember**: Specs are the source of truth. Tests define expected behavior. Your job is to bridge the gap between intent (specs) and implementation (code).

**Last Updated**: 2025-02-04
