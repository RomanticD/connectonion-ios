# Sprint 1 — Test Plan

**Project:** ConnectOnion Native iOS Client · **Test Lead:** Evan (Yifan Yang) · **Date:** 2026-06-22

## 1. Objective

Validate that the **currently implemented** functionality of the iOS client is correct and
demonstrable, and put in place the testing infrastructure (baseline run, coverage, traceability,
defect log) that later sprints will extend as new features land.

## 2. Scope

### In scope for Sprint 1
- Run and report the existing automated suite (unit + UI) with code coverage.
- Communication / protocol logic: address validation, CONNECT/INPUT encoding & signing, event reduction.
- Core chat workflows via UI tests (mock backend): send, streaming, approvals, ask-user, onboarding, plan review.
- One **real** end-to-end smoke test against a locally hosted `connectonion` agent.
- Manual / exploratory pass over implemented screens, including light/dark mode.
- Defect logging and a "known limitations" record.

### Out of scope for Sprint 1 (deferred — with rationale)
| Deferred item | Why deferred to a later sprint |
|---|---|
| Exhaustive negative/stress testing (timeout, mid-stream drop, reconnection) | Reconnection & error UX still evolving; lock down once stable |
| iPad-optimised layout testing | Proposal marks iPad as "where feasible"; not a Sprint 1 deliverable |
| Performance / load testing | Premature before feature set settles |
| Automated E2E (CI-driven, real agent) | Sprint 1 proves it manually first; automate later |
| Full accessibility (VoiceOver) audit | Spot-check now; formal audit when UI stabilises |

## 3. Test approach / levels

| Level | Tool | Backend | Owner |
|---|---|---|---|
| Unit | Swift Testing | In-memory mocks | Team (review by Test Lead) |
| UI / workflow | XCUITest (`--ui-testing`) | Seeded mock dependencies | Team (review by Test Lead) |
| Integration / E2E | Manual, scripted | **Real** `connectonion` agent over WebSocket | Test Lead |
| Exploratory | Manual, session-based | Mock + real | Test Lead |

## 4. Entry / exit criteria

**Entry:** app builds and launches on the Sprint 1 simulator baseline (✓ — see README environment).

**Exit (Sprint 1 "testing done"):**
- Automated suite executes; results + coverage recorded in `01_test-execution-report.md`.
- Every proposal requirement #1–9 has a row in `traceability-matrix.md` with a status.
- At least one real-agent E2E smoke test passes and is evidenced (`02_e2e-smoke-test.md`).
- Manual checklist completed; all defects logged in `defect-log.md`.
- `sprint1-test-summary.md` written, including consciously deferred scope.

## 5. Risks

| Risk | Mitigation |
|---|---|
| Tooling mismatch (project built for Xcode 27 / iOS 27) | Local iOS-26 build patch applied; baseline recorded for reproducibility |
| UI tests flaky on slower simulators | Generous `waitForExistence` timeouts already used; re-run on failure |
| Real agent unavailable | Host a local agent via the Python framework (`host()`) for E2E |
