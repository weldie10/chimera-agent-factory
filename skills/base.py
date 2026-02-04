"""
Base classes and interfaces for Chimera agent skills.

All skills must inherit from BaseSkill and implement the execute method.
"""

from abc import ABC, abstractmethod
from typing import Any, Dict
from pydantic import BaseModel, Field


class SkillInput(BaseModel):
    """Base class for skill input schemas"""
    pass


class SkillOutput(BaseModel):
    """Base class for skill output schemas"""
    success: bool = Field(description="Whether the skill execution was successful")
    error: str | None = Field(default=None, description="Error message if success is False")


class BaseSkill(ABC):
    """
    Base class for all Chimera agent skills.
    
    All skills must:
    1. Inherit from BaseSkill
    2. Define name, version, and description class attributes
    3. Implement the execute method
    """
    
    name: str
    version: str
    description: str
    
    @abstractmethod
    async def execute(self, input_data: SkillInput) -> SkillOutput:
        """
        Execute the skill with the given input.
        
        Args:
            input_data: Validated input data (Pydantic model)
            
        Returns:
            SkillOutput with success status and results/error
        """
        pass
    
    def __repr__(self) -> str:
        return f"<{self.__class__.__name__}(name={self.name}, version={self.version})>"
