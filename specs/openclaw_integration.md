# Project Chimera - OpenClaw Integration Specification

## Overview

Project Chimera agents must integrate with the **OpenClaw Agent Social Network** to enable inter-agent communication, capability discovery, and collaborative operations.

## OpenClaw Context

Based on research into OpenClaw and the Agent Social Network paradigm:
- **OpenClaw** is a protocol for agent-to-agent communication
- Agents can **announce capabilities** to the network
- Agents can **discover and request services** from other agents
- Agents maintain **social relationships** and **reputation** within the network

## Integration Goals

1. **Capability Announcement**: Chimera agents publish their skills to OpenClaw
2. **Service Discovery**: Chimera agents can find other agents with specific capabilities
3. **Request Handling**: Chimera agents can receive and process requests from other agents
4. **Status Broadcasting**: Chimera agents broadcast operational status in real-time

## Protocol Specification

### Agent Identity

Each Chimera agent has a unique identity in the OpenClaw network:

```json
{
  "agent_id": "chimera-{agent_type}-{instance_id}",
  "agent_type": "research|generate|publish",
  "capabilities": [
    {
      "skill_name": "skill_fetch_trends",
      "description": "Fetches trending topics from social platforms",
      "input_schema": {},
      "output_schema": {},
      "rate_limit": "100/hour"
    }
  ],
  "status": "available|busy|offline",
  "metadata": {
    "version": "0.1.0",
    "node_location": "us-east-1"
  }
}
```

### Capability Announcement

**Event**: `agent.announce`

**Payload**:
```json
{
  "event": "agent.announce",
  "agent_id": "chimera-research-001",
  "timestamp": "ISO8601",
  "capabilities": [
    {
      "skill_name": "skill_fetch_trends",
      "description": "Fetches trending topics",
      "input_schema": {
        "type": "object",
        "properties": {
          "platforms": {
            "type": "array",
            "items": {"type": "string"}
          },
          "time_range": {
            "type": "string",
            "enum": ["24h", "7d", "30d"]
          }
        },
        "required": ["platforms"]
      },
      "output_schema": {
        "type": "object",
        "properties": {
          "success": {"type": "boolean"},
          "trends": {"type": "array"}
        }
      }
    }
  ],
  "status": "available"
}
```

### Service Discovery

**Event**: `agent.discover`

**Request**:
```json
{
  "event": "agent.discover",
  "requester_id": "chimera-orchestrator-001",
  "query": {
    "capability": "skill_fetch_trends",
    "filters": {
      "status": "available",
      "rate_limit": {"$gte": 50}
    }
  },
  "timestamp": "ISO8601"
}
```

**Response**:
```json
{
  "event": "agent.discover.response",
  "requester_id": "chimera-orchestrator-001",
  "agents": [
    {
      "agent_id": "chimera-research-001",
      "capability": "skill_fetch_trends",
      "status": "available",
      "metadata": {}
    }
  ],
  "timestamp": "ISO8601"
}
```

### Service Request

**Event**: `agent.request`

**Request**:
```json
{
  "event": "agent.request",
  "request_id": "uuid",
  "requester_id": "chimera-orchestrator-001",
  "target_agent_id": "chimera-research-001",
  "skill_name": "skill_fetch_trends",
  "input": {
    "platforms": ["youtube", "tiktok"],
    "time_range": "24h"
  },
  "priority": "normal|high|low",
  "timeout": 30,
  "timestamp": "ISO8601"
}
```

**Response**:
```json
{
  "event": "agent.request.response",
  "request_id": "uuid",
  "requester_id": "chimera-orchestrator-001",
  "target_agent_id": "chimera-research-001",
  "status": "success|failure|timeout",
  "output": {
    "success": true,
    "trends": []
  },
  "execution_time": 2.5,
  "timestamp": "ISO8601"
}
```

### Status Broadcasting

**Event**: `agent.status.update`

**Payload**:
```json
{
  "event": "agent.status.update",
  "agent_id": "chimera-research-001",
  "status": "available|busy|offline",
  "current_operations": 2,
  "capacity": 10,
  "health": {
    "cpu_usage": 45.2,
    "memory_usage": 60.1,
    "error_rate": 0.01
  },
  "timestamp": "ISO8601"
}
```

## Implementation Strategy

### Phase 1: Announcement (Day 3)
- Implement `skill_openclaw_announce` skill
- Agent announces capabilities on startup
- Agent updates status when capabilities change

**Detailed Implementation Plan**:

1. **Initial Announcement on Startup**:
   ```python
   # On agent initialization
   await skill_openclaw_announce.execute(OpenClawAnnounceInput(
       agent_id="chimera-research-001",
       capabilities=[
           Capability(
               skill_name="skill_fetch_trends",
               description="Fetches trending topics from social platforms",
               rate_limit="100/hour"
           )
       ],
       status="available"
   ))
   ```

2. **Status Updates**:
   - When agent becomes busy: Update status to "busy"
   - When agent completes work: Update status to "available"
   - On graceful shutdown: Update status to "offline"
   - On error recovery: Re-announce with "available" status

3. **Capability Updates**:
   - When new skills are added: Re-announce with updated capabilities
   - When skills are deprecated: Re-announce with removed capabilities

### Phase 2: Discovery (Post-Day 3)
- Implement `skill_openclaw_discover` skill
- Agent can query OpenClaw network for other agents
- Agent caches discovered agents for performance

### Phase 3: Request Handling (Post-Day 3)
- Implement `skill_openclaw_handle_request` skill
- Agent validates incoming requests
- Agent executes requested skills
- Agent responds with standardized format

### Phase 4: Status Broadcasting (Post-Day 3)
- Implement periodic status updates
- Agent broadcasts health metrics
- Agent updates status based on workload

**Detailed Status Broadcasting Plan**:

1. **Periodic Updates**:
   - Broadcast status every 30 seconds when active
   - Broadcast status immediately on state change (available → busy, busy → available)
   - Include health metrics in each broadcast

2. **Status Transition Rules**:
   - `available`: Agent is idle and ready to accept requests
   - `busy`: Agent is processing requests (current_operations > 0)
   - `offline`: Agent is shutting down or unreachable

3. **Health Metrics Collection**:
   ```python
   health_metrics = {
       "cpu_usage": get_cpu_usage(),
       "memory_usage": get_memory_usage(),
       "error_rate": calculate_error_rate(),
       "active_operations": count_active_operations(),
       "queue_length": get_queue_length()
   }
   ```

4. **Status Update Triggers**:
   - On request received: Update to "busy" if was "available"
   - On request completed: Update to "available" if queue is empty
   - On error threshold exceeded: Update to "offline" and alert
   - On resource exhaustion: Update to "busy" and reject new requests

## MCP Integration

OpenClaw communication will be handled via an **OpenClaw MCP Server**:

- **MCP Server Name**: `openclaw-mcp`
- **Functions**:
  - `announce_capabilities(capabilities)`
  - `discover_agents(query)`
  - `send_request(target_agent, skill, input)`
  - `update_status(status, health)`

## Security Considerations

1. **Authentication**: All OpenClaw messages must be signed/verified
2. **Authorization**: Agents can restrict which agents can request their services
3. **Rate Limiting**: Prevent abuse of agent capabilities
4. **Input Validation**: All incoming requests validated against schemas

## Social Protocols

### Reputation System
- Agents maintain reputation scores based on:
  - Request success rate
  - Response time
  - Service quality
- High-reputation agents prioritized in discovery

### Collaboration Patterns
- **Chain Pattern**: Agent A → Agent B → Agent C
- **Parallel Pattern**: Agent A requests from multiple agents simultaneously
- **Orchestration Pattern**: Orchestrator coordinates multiple agents

## Testing Strategy

1. **Unit Tests**: Test OpenClaw message parsing and validation
2. **Integration Tests**: Test announcement and discovery flows
3. **E2E Tests**: Test full request/response cycle with mock OpenClaw network

## Future Enhancements

- **Agent Marketplace**: Agents can offer paid services
- **Collaborative Content**: Multiple agents collaborate on content generation
- **Learning Network**: Agents learn from each other's behavior

---

**Status**: ✅ Draft Complete  
**Last Updated**: 2025-02-04  
**Author**: Weldeyohans Nigus
