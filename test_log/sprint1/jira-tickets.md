# Sprint 1 — Jira tickets (QA / Testing)

Copy-paste content for the Jira board. Create an **Epic** then 5 **Tasks** under it.
Fill `[FILL]` with real numbers from the test run before closing.

---

## EPIC — `Sprint 1: Testing & QA`
**Description:**
> Establish the testing baseline and evidence for the ConnectOnion iOS client at Sprint 1: run the
> existing automated suite with coverage, build the test plan + requirements traceability, prove one
> real end-to-end interaction with a hosted agent, and document defects / known limitations.
> Evidence lives in `repo`-adjacent `test_log/sprint1/`.

---

## QA-1 — Establish automated test baseline + coverage
**Type:** Task · **Assignee:** Evan · **Story points:** 2
**Description / acceptance criteria:**
- [ ] Full suite (unit + UI) runs on the Sprint 1 simulator baseline.
- [ ] Pass/fail counts and line coverage recorded.
- [ ] Report committed to `test_log/sprint1/01_test-execution-report.md` with raw log + `.xcresult`.

**Closing comment (ready to paste):**
> ✅ Done. Ran full suite on `6f4586d` + iOS-26 build patch (Xcode 26.3 / iPhone 17 sim, iOS 26.3.1):
> **25/25 passed (10 unit + 15 UI), 0 failures**, app line coverage **70.77%**. AgentAddress (93%),
> ChatItem Codable (86%), ChatViewModel (84%) well covered; ChatEventReducer (43%), Keychain (9%) and
> route resolution (3%) low → tracked for Sprint 2. Evidence: `test_log/sprint1/01_test-execution-report.md`,
> `evidence/sprint1.xcresult`.

---

## QA-2 — Test plan & requirements traceability matrix
**Type:** Task · **Assignee:** Evan · **Story points:** 2
**Description / acceptance criteria:**
- [ ] Test plan documents Sprint 1 scope, levels, entry/exit criteria, and deferred items with rationale.
- [ ] Every proposal requirement #1–9 mapped to test case(s) with a status.

**Closing comment (template):**
> ✅ Done. Test plan + RTM cover all 9 requirements. Sprint 1 automates R1/R2/R3/R5/R7-happy; R4/R6/R8
> partial-manual; iPad + reconnection consciously deferred (rationale in plan §2). Files:
> `test_log/sprint1/test-plan.md`, `traceability-matrix.md`.

---

## QA-3 — End-to-end smoke test vs local agent
**Type:** Task · **Assignee:** Evan · **Story points:** 3
**Description / acceptance criteria:**
- [ ] A `connectonion` agent is hosted locally (`host()`).
- [ ] iOS app connects, sends a prompt, receives a streamed result to completion.
- [ ] Captured as screen recording + console screenshot.

**Closing comment (ready to paste):**
> ✅ Done & **passing**. Automated it as an XCUITest (`ConnectOnion_iOSE2ETests`) against a live local
> agent (`co/gemini-2.5-flash`, `trust="open"`, port 8000). Real round-trip verified: app Ed25519
> CONNECT → INPUT → agent `add(21,21)` tool call → "42" streamed to the chat UI. Result: **1 passed /
> 0 failed**. **Minimum deliverable met.** Evidence: `test_log/sprint1/02_e2e-smoke-test.md`,
> `evidence/e2e-smoke.mp4` (64.8s), `evidence/e2e-agent-host.log`. Note: free OpenOnion credits are
> Gemini-only (KL-6).

---

## QA-4 — Exploratory test pass + defect log
**Type:** Task · **Assignee:** Evan · **Story points:** 2
**Description / acceptance criteria:**
- [ ] Manual checklist completed over implemented features incl. light/dark mode.
- [ ] Heuristic usability spot-check done.
- [ ] All findings logged + Jira `QA-DEF-n` raised for defects.

**Closing comment (template):**
> ✅ Done. Manual pass: **`[FILL]`** items checked, **`[N]`** defects raised (`QA-DEF-…`). Usability
> spot-check (Nielsen) recorded. Details: `test_log/sprint1/03_manual-test-checklist.md`, `defect-log.md`.

---

## QA-5 — Sprint 1 test report
**Type:** Task · **Assignee:** Evan · **Story points:** 1
**Description / acceptance criteria:**
- [ ] One-page summary: results, coverage, defects, deferred scope, Sprint 2 recommendations.

**Closing comment (ready to paste; fill E2E/defect counts after manual pass):**
> ✅ Done. Sprint 1 testing summarised: **25/25 automated pass, 70.77% coverage**, E2E `[PASS]`,
> `[N]` defects. Sprint 2 plan: unit tests for persistence/Keychain/route resolution, remaining reducer
> events, CI automation. Report: `test_log/sprint1/sprint1-test-summary.md`.

---

### Optional defect tickets
`QA-DEF-1`, `QA-DEF-2`, … — one per defect in `defect-log.md`. Include severity, steps, expected vs
actual, and link back to the defect-log row.
