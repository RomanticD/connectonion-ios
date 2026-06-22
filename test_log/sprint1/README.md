# Sprint 1 — Testing & QA Log

**Project:** 97 — ConnectOnion Native iOS Client (Mobile Access to AI Agents)
**Client:** Aaron Xie · **Group:** COMP9900 Mon18
**Test Lead:** Evan (Yifan Yang)
**Sprint:** 1 · **Date:** 2026-06-22

---

## Purpose of this folder

Evidence that Sprint 1 testing was planned, executed, and documented — suitable for course
hand-over and traceable back to the project proposal's requirements.

**Sprint 1 testing philosophy:** the product is still growing, so this sprint does **not** aim for
exhaustive coverage. It aims to (1) establish a runnable test **baseline** + coverage, (2) stand up a
reusable **test plan / traceability** scaffold that grows each sprint, (3) prove the **minimum
end-to-end** path works against a real agent, and (4) document current defects and known limitations.

## Index

| File | What it is |
|------|------------|
| [test-plan.md](test-plan.md) | Scope, strategy, in/out of scope for Sprint 1 |
| [traceability-matrix.md](traceability-matrix.md) | Proposal requirements #1–9 → test cases → status |
| [01_test-execution-report.md](01_test-execution-report.md) | Ran the automated suite: pass/fail counts + coverage |
| [02_e2e-smoke-test.md](02_e2e-smoke-test.md) | Real end-to-end test vs a local ConnectOnion agent |
| [03_manual-test-checklist.md](03_manual-test-checklist.md) | Manual / exploratory pass over current features |
| [defect-log.md](defect-log.md) | Defects found + known limitations |
| [sprint1-test-summary.md](sprint1-test-summary.md) | One-page wrap-up (links everything) |
| `evidence/` | Screenshots, recordings, raw xcodebuild logs, coverage export |

## Build / test environment (baseline)

| Item | Value |
|------|-------|
| Host OS | macOS 15.7.4 (Sequoia) |
| Toolchain | Xcode 26.3 (iOS 26.2 SDK) |
| Simulator | iPhone 17 · iOS 26.3 |
| App under test | commit `6f4586d` + local iOS-26 build patch (`project.pbxproj`, `SidebarView.swift`) |
| Test frameworks | Swift Testing (unit) · XCTest/XCUITest (UI) |
