# Sprint 1 — Defect Log & Known Limitations

**Test Lead:** Evan (Yifan Yang) · **Date:** 2026-06-22

## Defects found

Severity: S1 crash/blocker · S2 major · S3 minor · S4 cosmetic.
File a matching Jira ticket (`QA-DEF-n`) for each and cross-link.

| ID | Severity | Area (Req) | Summary | Steps to reproduce | Expected | Actual | Jira | Status |
|----|----------|-----------|---------|--------------------|----------|--------|------|--------|
| DEF-1 | `[S?]` | `[R?]` | `[short title]` | `[1. … 2. …]` | `[…]` | `[…]` | `QA-DEF-1` | Open |
| | | | | | | | | |

_(No defects recorded yet — fill as found during the manual pass / E2E.)_

## Known limitations (intentional, this sprint)

These are **understood and accepted** for Sprint 1, not bugs — documented for hand-over (R8/R9).

| # | Limitation | Why / plan |
|---|------------|-----------|
| KL-1 | Project must be built with a local iOS-26 patch (`project.pbxproj` `objectVersion`/deployment target, `SidebarView.swift` toolbar APIs) | Source targets iOS 27 / Xcode 27; patch lets it build on Xcode 26.3. Revisit when team standardises toolchain. |
| KL-2 | Automated tests run entirely against mock dependencies | Real-agent path is verified manually this sprint (`02_e2e-smoke-test.md`); automated E2E deferred. |
| KL-3 | Reconnection / mid-stream network-loss not automated | Behaviour still evolving; locked down in a later sprint. |
| KL-4 | iPad layout not tested | Marked "where feasible" in proposal; out of Sprint 1 scope. |
| KL-6 | E2E agent must use a **Gemini** model (`co/gemini-2.5-flash`) | The free OpenOnion managed credits reject paid models — `co/o4-mini` returned HTTP 403 `paid_account_required`. Not an app defect; a backend/account constraint for the test harness. |
| KL-7 | E2E test is opt-in (skips unless `TEST_RUNNER_E2E_AGENT_ADDRESS` is set) and needs a live local agent + booted simulator | Keeps it out of the normal mocked suite/CI; run manually per `02_e2e-smoke-test.md`. Automate in CI in a later sprint. |
| KL-5 | `[add as discovered]` | |
