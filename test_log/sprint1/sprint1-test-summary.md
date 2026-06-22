# Sprint 1 — Test Summary

**Project:** ConnectOnion Native iOS Client · **Test Lead:** Evan (Yifan Yang) · **Date:** 2026-06-22

One-page wrap-up of Sprint 1 QA. Full detail in the linked artifacts in this folder.

## What was done this sprint
1. Established a runnable **test baseline** on a patched iOS-26 build and executed the full automated
   suite (unit + UI) with code coverage → [01_test-execution-report.md](01_test-execution-report.md).
2. Authored the **test plan** and **requirements traceability matrix** mapping all 9 proposal
   requirements to test cases → [test-plan.md](test-plan.md), [traceability-matrix.md](traceability-matrix.md).
3. Built and **passed** an automated **real end-to-end** test (`ConnectOnion_iOSE2ETests`) against a
   locally hosted `connectonion` agent — real Ed25519 handshake → prompt → `add` tool call → "42"
   streamed to the UI (minimum deliverable) → [02_e2e-smoke-test.md](02_e2e-smoke-test.md).
4. Completed a **manual / exploratory** pass + heuristic usability spot-check over implemented features →
   [03_manual-test-checklist.md](03_manual-test-checklist.md).
5. Logged **defects + known limitations** → [defect-log.md](defect-log.md).

## Results at a glance
| Metric | Value |
|--------|-------|
| Automated tests passed | **25 / 25** (10 unit + 15 UI), 0 failures |
| App line coverage | **70.77%** (4803/6787) |
| Real-agent E2E smoke | **✅ PASS** (automated XCUITest vs live agent; `add` tool round-trip → "42") |
| Manual checklist | `[FILL] items, [N] defects — fill after 03_manual-test-checklist.md]` |
| Defects open (S1/S2) | `[FILL]` |

## Coverage vs proposal requirements
- **Automated, solid:** R1/R2/R3 protocol & chat logic, R5 agent management, R7 failure path.
- **Manual / partial:** R4 persistence, R6 UX (light/dark, a11y), R8 usability.
- **Consciously deferred (with rationale):** R6 iPad, R7 reconnection/stress, automated E2E — see
  [test-plan.md](test-plan.md) §2 and KL-2..KL-4 in [defect-log.md](defect-log.md).

## Recommendations for Sprint 2
- Add unit tests for the **stable foundations** still uncovered: `ChatItem`/`ConversationRecord`
  Codable round-trip (R4), `KeychainIdentityStore` (R5), `AgentDirectoryService.resolveRoute` (R1).
- Cover remaining `ChatEventReducer` event types (llm_call, intent, eval, compact, …) (R3).
- Automate the E2E smoke in CI (GitHub Actions running `xcodebuild test`).
- Begin reconnection / network-loss testing once that UX stabilises.

## Sign-off
Tested by: **Evan (Yifan Yang)**, Test Lead — 2026-06-22.
