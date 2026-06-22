# Sprint 1 — Manual / Exploratory Test Checklist

**Test Lead:** Evan (Yifan Yang) · **Date:** 2026-06-22
**Device:** iPhone 17 simulator · iOS 26.3 · **Build:** commit `6f4586d` + iOS-26 patch
**Backend:** mock (`--ui-testing` seed) unless noted “real” → see `02_e2e-smoke-test.md`

Tick each item, record the actual result, and raise a `defect-log.md` entry for anything that fails.

## §Connection (R1)
- [ ] Add agent with a valid `0x…` address → saved & selectable — `[FILL]`
- [ ] Add agent with an invalid address → rejected with clear message — `[FILL]`
- [ ] Connection status indicator reflects online/offline — `[FILL]`

## §Chat (R2, R3)
- [ ] Send a message → user bubble + streaming response render — `[FILL]`
- [ ] List auto-scrolls to newest message — `[FILL]`
- [ ] Long agent response is readable (wrapping, code blocks) — `[FILL]`
- [ ] Stop button appears while running, hides when idle — `[FILL]`
- [ ] Approval card: Approve / Always / Skip each resolve correctly — `[FILL]`
- [ ] Ask-user (text / options / fields) all submit — `[FILL]`
- [ ] Plan review approve / revise works — `[FILL]`

## §Persistence (R4)
- [ ] Start new conversation → appears in sidebar — `[FILL]`
- [ ] Force-quit & relaunch → conversations + messages persist — `[FILL]`
- [ ] Reopen a previous conversation → full history intact — `[FILL]`
- [ ] Conversations are grouped/labelled by agent — `[FILL]`

## §Agent management (R5)
- [ ] Rename agent (alias) persists — `[FILL]`
- [ ] Edit endpoint persists — `[FILL]`
- [ ] Delete agent removes it + its conversations — `[FILL]`
- [ ] Address field is locked when editing — `[FILL]`

## §UX (R6)
- [ ] Light mode renders correctly — `[FILL]`
- [ ] Dark mode renders correctly (contrast, glass surfaces) — `[FILL]`
- [ ] Keyboard: input bar avoids keyboard, dismiss works — `[FILL]`
- [ ] Dynamic Type (larger text) — layout holds — `[FILL]`
- [ ] VoiceOver spot-check: key buttons have labels — `[FILL]`

## §Errors (R7)
- [ ] Connect to an offline / wrong endpoint → friendly error, no crash — `[FILL]`
- [ ] Lose network mid-request → understandable failure state — `[FILL]`

## §Usability evaluation (R8) — Nielsen heuristic spot-check
Rate 1–5 + note any issue (raise defects for low scores):
- [ ] Visibility of system status (loading/streaming/done clarity) — `[score + note]`
- [ ] Match to real world (wording, icons) — `[score + note]`
- [ ] User control & freedom (cancel/stop/back) — `[score + note]`
- [ ] Error prevention & recovery — `[score + note]`
- [ ] Aesthetic & minimalist design — `[score + note]`

**Summary of manual pass:** `[FILL — X/Y items passed, N defects raised]`
