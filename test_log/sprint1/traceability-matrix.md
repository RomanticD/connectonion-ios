# Requirements Traceability Matrix — Sprint 1

**Project:** ConnectOnion Native iOS Client · **Test Lead:** Evan (Yifan Yang) · **Date:** 2026-06-22
**App under test:** commit `6f4586d` + local iOS-26 build patch

Maps each proposal **functional requirement (#1–9)** to the test cases that exercise it and their
Sprint 1 status. This is a **living document** — new tests are added as features land.

**Status legend:** ✅ Covered (automated) · 🟡 Partial / manual only · ⏳ Planned (this/next sprint) · ⛔ Deferred (see test-plan §2)

---

## Requirement → Test coverage

### R1. Agent Connection
| Test case | Type | Location | Status |
|---|---|---|---|
| Address normalize + validate (good/short/non-hex) | Unit | `AgentAddressTests.normalizesAndValidatesAgentAddresses` | ✅ |
| CONNECT message: signed envelope + session state | Unit | `ProtocolCodecTests.connectMessageIncludesSignedEnvelopeAndSessionState` | ✅ |
| Onboarding gate on connect (invite) | UI | `testOnboardingInviteFlowResponds` | ✅ |
| Real connection to a live agent (Ed25519 handshake, direct endpoint route) | E2E | `ConnectOnion_iOSE2ETests` / `02_e2e-smoke-test.md` | ✅ |
| Connection status display / invalid connection handling | Manual | `03_manual-test-checklist.md` §Connection | 🟡 |
| `AgentDirectoryService.resolveRoute` priority (LAN→relay), preferred endpoint, unreachable | Unit | _planned_ | ⏳ |

### R2. Chat-Based Agent Interaction
| Test case | Type | Location | Status |
|---|---|---|---|
| INPUT message: prompt + attachments + signed payload | Unit | `ProtocolCodecTests.inputMessageCarriesAttachmentsAndSignedPayload` | ✅ |
| Send message → mock streaming response renders | UI | `testStandardComposerSendsMockStreamingResponse` | ✅ |
| Seeded conversation opens into usable chat shell | UI | `testSeededAgentLaunchesIntoUsableShell` | ✅ |
| New chat picker → start prompt | UI | `testNewChatButtonOpensAgentPickerAndStartsPrompt` | ✅ |
| Auto-scroll / timestamps / long-response rendering | Manual | `03_manual-test-checklist.md` §Chat | 🟡 |

### R3. Response & Execution Feedback
| Test case | Type | Location | Status |
|---|---|---|---|
| tool_call + tool_result merge into one card | Unit | `ChatEventReducerTests.toolEventsAreMergedIntoOneRenderableCard` | ✅ |
| ask_user → waiting state + answer stored | Unit | `ChatEventReducerTests.askUserEventMovesSessionToWaitingAndStoresAnswer` | ✅ |
| approval resolve (approve/always/skip) | UI+Unit | `testApprovalActionsResolve...`, `ChatEventReducerTests.approvalResponse...` | ✅ |
| ask_user text / options / fields flows | UI | `testAskUserText/Options/FieldsFlowResponds` | ✅ |
| plan_review approve / revise | UI+Unit | `testPlanReviewApproveAndReviseFlowsRespond`, `ChatEventReducerTests.planReview...` | ✅ |
| Remaining event types (llm_call, assistant, intent, eval, compact, tool_blocked, files_received) | Unit | _planned_ | ⏳ |
| Real streamed tool round-trip → answer ("42") | E2E | `ConnectOnion_iOSE2ETests` / `02_e2e-smoke-test.md` | ✅ |

### R4. Conversation Management
| Test case | Type | Location | Status |
|---|---|---|---|
| Start new conversation | UI | `testNewChatButtonOpensAgentPickerAndStartsPrompt` | ✅ |
| Empty-state hides section titles | UI | `testEmptyShellHidesSectionTitlesAndShowsAddAgentState` | ✅ |
| Persistence round-trip (`ChatItem` Codable, `ConversationRecord` ↔ SwiftData) | Unit | _planned_ | ⏳ |
| History survives app relaunch; reopen prior conversation | Manual | `03_manual-test-checklist.md` §Persistence | 🟡 |

### R5. Agent & Connection Management
| Test case | Type | Location | Status |
|---|---|---|---|
| Rename/delete/edit endpoint via long-press | UI | `testAgentLongPressExposesRenameDeleteAndEndpointEditing` | ✅ |
| Rename/delete/edit endpoint via actions menu | UI | `testAgentActionsMenuExposesRenameDeleteAndEndpointEditing` | ✅ |
| Address field locked on edit | UI | (asserted in both above) | ✅ |
| Secure storage (Keychain) of identity/credentials | Unit | _planned_ (`KeychainIdentityStore` round-trip) | ⏳ |

### R6. Native iOS User Experience
| Test case | Type | Location | Status |
|---|---|---|---|
| Desktop-only command palette hidden on mobile | UI | `testAgentLandingHidesDesktopSkillCommandPalette` | ✅ |
| Sidebar agent list reachable | UI | `testAgentListIsAccessibleWhenSidebarIsVisible` | ✅ |
| Light / dark mode | Manual | `03_manual-test-checklist.md` §UX | 🟡 |
| Keyboard behaviour, Dynamic Type, VoiceOver spot-check | Manual | `03_manual-test-checklist.md` §UX | 🟡 |
| iPad-optimised layout | — | — | ⛔ deferred |

### R7. Reliability & Error Handling
| Test case | Type | Location | Status |
|---|---|---|---|
| Failed connection → no working state, no optimistic persist, friendly error | Unit | `ChatViewModelTests.failedConnectionDoesNotEnterWorkingStateOrPersistOptimisticMessage` | ✅ |
| First prompt that triggers onboarding rolls back cleanly | Unit | `ChatViewModelTests.firstPromptThatTriggersOnboardingKeepsSuggestionsAvailableAfterInviteSubmit` | ✅ |
| Invalid endpoint / offline messaging | Manual | `03_manual-test-checklist.md` §Errors | 🟡 |
| Mid-stream network loss, timeout, reconnection (`rewind_to`) | — | — | ⛔ deferred |

### R8. Testing & Quality Assurance
| Deliverable | Location | Status |
|---|---|---|
| Automated suite executed + coverage | `01_test-execution-report.md` | see report |
| Test plan | `test-plan.md` | ✅ |
| Traceability matrix (this file) | `traceability-matrix.md` | ✅ |
| Defect log + known limitations | `defect-log.md` | ✅ (ongoing) |
| Basic usability evaluation | `03_manual-test-checklist.md` §Usability | 🟡 |

### R9. Documentation & Handover
| Deliverable | Location | Status |
|---|---|---|
| Testing evidence captured & indexed | this folder (`test_log/sprint1/`) | ✅ |
| Sprint test summary + recommendations | `sprint1-test-summary.md` | ✅ |

---

## Sprint 1 coverage snapshot

- **Automated suite:** 25/25 passing (10 unit + 15 UI), **app line coverage 70.77%** (see `01_test-execution-report.md`).
- **Automated-covered requirements:** R1, R2, R3, R5 (core paths), R7 (happy + 1 failure path)
- **Manual / partial this sprint:** R4 persistence, R6 UX polish, R8 usability
- **Consciously deferred:** iPad (R6), reconnection/stress (R7) — see `test-plan.md` §2
- **Low-coverage modules → Sprint 2 unit targets (⏳ rows above):** ChatEventReducer 43%,
  AgentDirectoryService 3%, KeychainIdentityStore 9%, ConnectOnionClient 3%.
