# Sprint 1 — End-to-End Smoke Test (real agent)

**Test Lead:** Evan (Yifan Yang) · **Date:** 2026-06-22 · **Result: ✅ PASS**
**Maps to:** proposal minimum deliverable *"Successful end-to-end interaction with at least one
ConnectOnion agent"* + requirements R1 (connection), R2 (chat), R3 (streaming/execution feedback).

> Every other test in this sprint runs against **mocks**. This one proves the real protocol works:
> the iOS app talking to an actual `connectonion` Python agent over a real WebSocket, including the
> Ed25519 handshake, a real LLM call, and a real tool invocation streamed back to the UI.

This was automated as an XCUITest — `ConnectOnion iOSUITests/ConnectOnion_iOSE2ETests.swift` — so it is
**repeatable**, not a one-off manual click-through. It launches the app *without* `--ui-testing`, so it
uses the real networking + persistence stack (not seeded mocks).

## How it was run

**1. Host a real agent** (Python framework, `repo/connectonion`):

`server.py` (saved as `evidence/e2e-agent-server.py`):
```python
from pathlib import Path
from connectonion import Agent, host

def add(a: int, b: int) -> int:
    """Add two integers and return the sum."""
    return a + b

def create_agent():
    return Agent(name="assistant", tools=[add], model="co/gemini-2.5-flash",
                 system_prompt="You are a helpful assistant. Keep replies to one short sentence.")

host(create_agent, port=8000, trust="open", relay_url=None, co_dir=Path.home() / ".co")
```
```bash
co auth          # one-time: signature auth → managed OPENONION_API_KEY (Gemini free tier)
python server.py # hosts on http://localhost:8000, prints the agent's 0x address
```
> **Note:** the free OpenOnion credits only cover **Gemini** models — `co/o4-mini` returned HTTP 403
> `paid_account_required`, so the agent uses `co/gemini-2.5-flash`. (Recorded as KL-6 in `defect-log.md`.)

**2. Run the E2E test** against the live agent (simulator reaches the Mac's `localhost`):
```bash
export TEST_RUNNER_E2E_AGENT_ADDRESS=0x6c4ca383...df270c
export TEST_RUNNER_E2E_AGENT_ENDPOINT=http://localhost:8000
xcodebuild test -scheme "ConnectOnion iOS" \
  -destination 'platform=iOS Simulator,id=<booted iPhone 17 UDID>' \
  -only-testing:"ConnectOnion iOSUITests/ConnectOnion_iOSE2ETests" \
  -parallel-testing-enabled NO
# record the screen in parallel:
xcrun simctl io <UDID> recordVideo --codec h264 evidence/e2e-smoke.mp4
```

## Steps & results

| # | Step | Expected | Actual | Pass? |
|---|------|----------|--------|-------|
| 1 | App configures the live agent (address + `http://localhost:8000`) | Agent saved, chat reachable | Agent opened, chat input shown | ✅ |
| 2 | Send "What is 21 plus 21? Use the add tool and tell me the result." | Connects + streams | Connected, streamed | ✅ |
| 3 | Real Ed25519 handshake | Agent authenticates client | `✓ CONNECT identity=0x57ac27a6… status=new` | ✅ |
| 4 | Prompt delivered | Agent receives INPUT | `✓ INPUT … prompt=What is 21 plus 21?…` | ✅ |
| 5 | Tool round-trip | `add` tool called with 21,21 | `[co] ▸ add(a=21, b=21) ✓ 0.00s` | ✅ |
| 6 | Answer streamed to UI | UI shows "42" | XCUITest asserted a static text containing **"42"** | ✅ |

**Automated test result:** `1 passed, 0 failed, 0 skipped` — `** TEST SUCCEEDED **`.

## Evidence (in `evidence/`)

- **`e2e-smoke.mp4`** — 40 s demo (trimmed to the app interaction) showing the **full flow**:
  iOS **home screen → app launch animation** → empty app → **Add Agent** (paste address `0x6c4ca383…`,
  name, endpoint `http://localhost:8000`) → Save → agent landing → send prompt → `add` tool card →
  **"The sum of 21 and 21 is 42."** (result held on screen for 5 s).
- **`e2e-smoke.gif`** — 301 KB condensed GIF (~10 s, 300 px) of the same flow, for Jira / the report.
- `e2e-still-0-launch.png` — the app opening from the home screen.
- `e2e-still-1-add-agent.png` — the Add Agent form (address + endpoint filled).
- `e2e-still-2-result.png` — the chat showing the `add` tool call + "…is 42." answer.
- `e2e-smoke-full.mp4` — untrimmed recording (includes build/install idle time) for completeness.
- `e2e-agent-host.log` — agent-side log: CONNECT → INPUT → `add(21,21)` → result.
- `e2e-agent-server.py` — the hosted agent script.
- `e2e-test.log` + `e2e.xcresult` — xcodebuild test output / result bundle.

> **Note:** the full-resolution `e2e-smoke.mp4` / `e2e-smoke-full.mp4` and the `*.xcresult` bundles are
> large and **git-ignored** (kept out of the repo). The **GIF + PNG stills above are the in-repo visual
> evidence**; the full videos are available on the team's shared drive / on request.

### Agent-side proof (excerpt from `e2e-agent-host.log`)
```
✓ CONNECT identity=0x57ac27a6276036... session=CDB84823... status=new
✓ INPUT   identity=0x57ac27a6276036... prompt=What is 21 plus 21? Use the add tool...
[co] > "What is 21 plus 21? Use the add tool and tell me the result."
[co]   ▸ add(a=21, b=21)                               ✓ 0.00s
```

## Result

**✅ PASS** — Real end-to-end interaction succeeded: the iOS client connected to a live ConnectOnion
agent over WebSocket (real Ed25519 auth), sent a prompt, the agent ran a real LLM + tool call, and the
"42" result streamed back into the chat UI. **Minimum deliverable met.**

**Notes:** identity `0x57ac27a6…` is the iOS client's own auto-generated Keychain identity; `0x6c4ca383…`
is the agent. Free-tier model constraint logged as KL-6.
