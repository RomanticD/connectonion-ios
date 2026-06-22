# Sprint 1 — Automated Test Execution Report

**Test Lead:** Evan (Yifan Yang) · **Date:** 2026-06-22
**Maps to:** R8 (Testing & QA), R3/R1/R2 (logic covered by the suite)

## How to reproduce

```bash
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
cd "repo/connectonion-ios"
xcodebuild test -scheme "ConnectOnion iOS" \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -enableCodeCoverage YES \
  -resultBundlePath ".../test_log/sprint1/evidence/sprint1.xcresult"
```

Coverage export:
```bash
xcrun xccov view --report --only-targets ".../evidence/sprint1.xcresult"
```

## Environment

| Item | Value |
|------|-------|
| Host | macOS 15.7.4 · Xcode 26.3 (iOS 26.2 SDK) |
| Simulator | iPhone 17 · iOS 26.3.1 |
| App under test | commit `6f4586d` + local iOS-26 build patch |
| Date/time of run | 2026-06-22 |

## Results

| Suite | Framework | Tests | Passed | Failed | Result |
|-------|-----------|-------|--------|--------|--------|
| ConnectOnion iOSTests (unit) | Swift Testing | 10 | 10 | 0 | ✅ Passed |
| ConnectOnion iOSUITests (UI) | XCUITest | 15 | 15 | 0 | ✅ Passed |
| **Total** | | **25** | **25** | **0** | **✅ TEST SUCCEEDED** |

Raw log: `evidence/xcodebuild-test.log` · Result bundle: `evidence/sprint1.xcresult`
(Unit groups: AgentAddressTests ×1, ProtocolCodecTests ×2, ChatEventReducerTests ×5, ChatViewModelTests ×2.)

## Code coverage

| Target | Line coverage |
|--------|---------------|
| **ConnectOnion iOS (app)** | **70.77%** (4803/6787) |
| ConnectOnion iOSTests.xctest | 94.70% |
| ConnectOnion iOSUITests.xctest | 87.41% |
| Factory (3rd-party dep) | 27.63% (excluded from our target) |

### Coverage of key source files (app target)
| File | Coverage | Read |
|------|----------|------|
| `Core/Models/AgentAddress.swift` | 93.33% | ✅ well covered |
| `Features/Shell/SidebarView.swift` | 92.48% | ✅ |
| `Core/Models/ChatItem.swift` (Codable) | 85.94% | ✅ |
| `Features/Chat/ChatViewModel.swift` | 84.47% | ✅ |
| `Core/Persistence/ConversationRecord.swift` | 75.00% | 🟡 |
| `Core/Network/ProtocolCodec.swift` | 63.06% | 🟡 |
| `Core/Chat/ChatEventReducer.swift` | 43.31% | 🟡 only 5 of ~20 event types tested |
| `Core/Crypto/KeychainIdentityStore.swift` | 8.70% | ❌ identity not unit-tested |
| `Core/Network/ConnectOnionClient.swift` | 3.21% | ❌ real client only exercised via mock |
| `Core/Network/AgentDirectoryService.swift` | 2.72% | ❌ route resolution not tested |

Coverage export: `evidence/coverage-report.txt` · Result bundle: `evidence/sprint1.xcresult`

**Interpretation (Sprint 1):** The protocol/logic core is in good shape — `AgentAddress` (93%),
`ChatItem` Codable (86%), `ChatViewModel` (84%) and `ProtocolCodec` (63%) are exercised by the unit +
UI suites. The coverage data **empirically confirms the gaps flagged in the traceability matrix**:
`ChatEventReducer` (43% — only tool/ask_user/approval/onboard/plan_review of ~20 event types),
`KeychainIdentityStore` (9%), `ConnectOnionClient` (3%) and `AgentDirectoryService` (3%) are low because
they are bypassed by mocks. These are the exact targets queued as ⏳ for Sprint 2 unit tests.

## Conclusion

Suite is **green: 25/25 passing, 0 failures**. App line coverage **70.77%**. No defects from automated
run; identified low-coverage modules are tracked as Sprint 2 work, not defects.
