"""
Chimera Agent Skills

This module provides the skill registry and base classes for all Chimera agent skills.
"""

# Skill registry will be populated as skills are implemented
SKILL_REGISTRY: dict[str, type] = {}

# Placeholder for future skill imports
# from skills.skill_fetch_trends import SkillFetchTrends
# from skills.skill_download_video import SkillDownloadVideo
# etc.

# SKILL_REGISTRY = {
#     "skill_fetch_trends": SkillFetchTrends,
#     "skill_download_video": SkillDownloadVideo,
#     # ... etc
# }

__all__ = ["SKILL_REGISTRY"]
