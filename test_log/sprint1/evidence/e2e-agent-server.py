"""E2E smoke-test agent for the ConnectOnion iOS client (COMP9900 Mon18, Sprint 1)."""
from pathlib import Path
from connectonion import Agent, host


def add(a: int, b: int) -> int:
    """Add two integers and return the sum."""
    return a + b


def create_agent():
    return Agent(
        name="assistant",
        system_prompt="You are a helpful assistant for an iOS E2E test. Keep replies to one short sentence.",
        tools=[add],
        model="co/gemini-2.5-flash",
    )


# Local-only (no relay), open trust, reuse the authed ~/.co identity.
host(create_agent, port=8000, trust="open", relay_url=None, co_dir=Path.home() / ".co")
