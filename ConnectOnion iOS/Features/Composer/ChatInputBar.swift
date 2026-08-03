//
//  ChatInputBar.swift
//
//  Purpose: Implements ChatInputBar for the Features/Composer module.
//  Collaborates with: AttachmentSheet, AttachmentStrip, CameraPicker, ComposerAttachmentPreviews, RecentPhotos, SkillCommandPalette.
//  References: Apple Swift documentation (https://developer.apple.com/documentation/swift) and
//               the project architecture described in README.md where applicable.
//
//  This file is part of the ConnectOnion iOS application.
//
import SwiftUI
import UniformTypeIdentifiers

struct ChatInputBar: View {
    var placeholder: String
    var isRunning: Bool
    var acceptedInputs: AgentAcceptedInputs?
    var skills: [SkillInfo]
    var onSend: (String, [String], [FileAttachment]) -> Void
    var onStop: () -> Void

    @AppStorage(CustomInstructions.storageKey) private var customInstructions = ""
    @AppStorage(PersonalityMode.storageKey) private var personality: PersonalityMode = .pragmatic
    @State private var text = ""
    @State private var fileAttachments: [FileAttachment] = []
    @State private var voiceInput = VoiceInputTranscriber()
    @State private var showingAttachmentOptions = false
    @State private var showingFileImporter = false
    @State private var attachmentError: String?
    @State private var voiceSeedText = ""
    @State private var voiceOriginalText = "" // exact pre-dictation text, restored on ✕
    @State private var voiceLastApplied = "" // last text written from a transcript, to detect manual edits
    @State private var feedbackTrigger = 0
    @State private var errorFeedbackTrigger = 0
    @FocusState private var isFocused: Bool

    init(
        placeholder: String,
        isRunning: Bool,
        acceptedInputs: AgentAcceptedInputs? = nil,
        skills: [SkillInfo] = [],
        onSend: @escaping (String, [String], [FileAttachment]) -> Void,
        onStop: @escaping () -> Void
    ) {
        self.placeholder = placeholder
        self.isRunning = isRunning
        self.acceptedInputs = acceptedInputs
        self.skills = skills
        self.onSend = onSend
        self.onStop = onStop
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if hasAttachments {
                ComposerAttachmentPreviewStrip(
                    files: fileAttachments,
                    onRemoveFile: removeFile
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            if let attachmentError {
                Label(attachmentError, systemImage: "exclamationmark.circle.fill")
                    .appFont(.caption)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 8)
                    .accessibilityIdentifier(AccessibilityID.chatAttachmentError)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }

            if let voiceError = voiceInput.errorMessage {
                Label(voiceError, systemImage: "mic.slash.fill")
                    .appFont(.caption)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 8)
                    .accessibilityIdentifier(AccessibilityID.chatVoiceError)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }

            if shouldShowSkillPalette {
                SkillCommandPalette(skills: filteredSkills, onSelect: selectSkill)
                    .transition(AppMotion.panelTransition)
            }

            // Row 1: the text field spans the full width. It stays visible during dictation so the
            // streaming transcript is readable while the keyboard remains up.
            TextField("", text: $text, axis: .vertical)
                .lineLimit(1...6)
                .textFieldStyle(.plain)
                .tint(.primary)
                .focused($isFocused)
                .submitLabel(.send)
                .onSubmit(send)
                // Custom placeholder: the system placeholder (~30% white) is nearly invisible on the
                // dark glass bar. A concrete light gray reads clearly and resists the glass vibrancy.
                .overlay(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundStyle(Color(.systemGray))
                            .allowsHitTesting(false)
                            .accessibilityHidden(true)
                    }
                }
                .padding(.horizontal, 6)
                .padding(.top, 8)
                .accessibilityIdentifier(AccessibilityID.chatInput)

            if voiceInput.isActive {
                // Row 2 (dictation): cancel ✕, live waveform, confirm ✓.
                VoiceRecordingBar(
                    voice: voiceInput,
                    onCancel: cancelVoiceInput,
                    onConfirm: confirmVoiceInput
                )
                .transition(.opacity)
            } else {
                // Row 2: attach on the left, mic + send (or stop) on the right.
                HStack(spacing: 10) {
                    if allowsAttachments {
                        Button("Add attachment", systemImage: "plus", action: showAttachmentMenu)
                            .labelStyle(.iconOnly)
                            .frame(width: 38, height: 38)
                            .buttonStyle(.glass)
                            .disabled(remainingAttachmentSlots == 0)
                            .accessibilityIdentifier(AccessibilityID.chatAttachmentButton)
                    }

                    Spacer(minLength: 0)

                    if isRunning {
                        Button("Stop", systemImage: "stop.fill", action: stop)
                            .labelStyle(.iconOnly)
                            .frame(width: 40, height: 40)
                            .buttonStyle(.glass)
                            .accessibilityIdentifier(AccessibilityID.chatStopButton)
                            .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    } else {
                        Button(voiceButtonTitle, systemImage: voiceButtonSystemImage, action: toggleVoiceInput)
                            .labelStyle(.iconOnly)
                            .frame(width: 40, height: 40)
                            .buttonStyle(.glass)
                            .accessibilityIdentifier(AccessibilityID.chatVoiceButton)

                        // Ready: a filled brand-violet circle with a white arrow — the single primary
                        // action. Empty: fall back to the SAME neutral `.glass` as the +/mic buttons so
                        // the arrow stays clearly visible, instead of `.glassProminent`+`.disabled` which
                        // renders a washed-out light capsule whose arrow nearly disappears in dark mode.
                        if canSend {
                            Button("Send", systemImage: "arrow.up", action: send)
                                .labelStyle(.iconOnly)
                                .font(.headline.weight(.semibold))
                                .frame(width: 40, height: 40)
                                .buttonStyle(.glassProminent)
                                .tint(.onion)
                                .foregroundStyle(.white)
                                .accessibilityIdentifier(AccessibilityID.chatSendButton)
                                .transition(.opacity.combined(with: .scale(scale: 0.9)))
                        } else {
                            // send() already no-ops on empty input, so leaving it tappable is harmless and
                            // keeps full contrast (a `.disabled` glass would dim the arrow again).
                            Button("Send", systemImage: "arrow.up", action: send)
                                .labelStyle(.iconOnly)
                                .font(.headline.weight(.semibold))
                                .frame(width: 40, height: 40)
                                .buttonStyle(.glass)
                                .accessibilityIdentifier(AccessibilityID.chatSendButton)
                                .transition(.opacity.combined(with: .scale(scale: 0.9)))
                        }
                    }
                }
            }
        }
        .padding(10)
        .frame(maxWidth: AppTheme.composerMaxWidth)
        // The bar is a container, not a control — `.interactive()` glass here rests in a dim/flat state
        // and only "wakes up" (renders the full material, placeholder legible) once it's touched. Plain
        // regular glass renders correctly from first appearance. The inner buttons stay interactive.
        .glassSurface(cornerRadius: 28)
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showingAttachmentOptions) {
            AttachmentSheet(
                onFiles: { showingFileImporter = true }
            )
        }
        .fileImporter(
            isPresented: $showingFileImporter,
            allowedContentTypes: [.item],
            allowsMultipleSelection: true,
            onCompletion: handleFileImport
        )
        .onChange(of: voiceInput.transcript) { _, transcript in
            applyVoiceTranscript(transcript)
        }
        .onDisappear {
            voiceInput.cancel()
        }
        .animation(AppMotion.quick, value: isRunning)
        .animation(AppMotion.standard, value: hasAttachments)
        .animation(AppMotion.quick, value: voiceInput.state)
        .animation(AppMotion.quick, value: attachmentError)
        .animation(AppMotion.quick, value: voiceInput.errorMessage)
        .animation(AppMotion.quick, value: shouldShowSkillPalette)
        .sensoryFeedback(.selection, trigger: feedbackTrigger)
        .sensoryFeedback(.error, trigger: errorFeedbackTrigger)
    }

    private var hasAttachments: Bool {
        !fileAttachments.isEmpty
    }

    private var allowsAttachments: Bool {
        allowsFiles
    }

    private var allowsFiles: Bool {
        acceptedInputs?.files != nil || acceptedInputs == nil
    }

    private var maxAttachmentCount: Int {
        acceptedInputs?.files?.maxFilesPerRequest ?? AttachmentEncoding.defaultMaxAttachmentCount
    }

    private var maxFileSizeBytes: Int {
        (acceptedInputs?.files?.maxFileSizeMB ?? 10) * 1024 * 1024
    }

    private var maxInputFramePayloadBytes: Int {
        AttachmentEncoding.defaultMaxInputFrameBytes - AttachmentEncoding.defaultInputFrameSafetyMarginBytes
    }

    private var currentAttachmentCount: Int {
        fileAttachments.count
    }

    private var remainingAttachmentSlots: Int {
        max(0, maxAttachmentCount - currentAttachmentCount)
    }

    private var canSend: Bool {
        !voiceInput.isActive && (!text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || hasAttachments)
    }

    private var shouldShowSkillPalette: Bool {
        !voiceInput.isActive && !filteredSkills.isEmpty
    }

    private var skillQuery: String? {
        guard text.hasPrefix("/") else { return nil }
        let afterSlash = text.dropFirst()
        // Once a space is typed the command name is committed — stop matching so the palette dismisses
        // instead of lingering (showing the one already-chosen skill) over the rest of the message.
        guard !afterSlash.contains(" ") else { return nil }
        return String(afterSlash)
    }

    private var filteredSkills: [SkillInfo] {
        guard let skillQuery else { return [] }
        return skills
            .filter { skill in
                skillQuery.isEmpty || skill.name.localizedCaseInsensitiveContains(skillQuery)
            }
    }

    private var voiceButtonTitle: String {
        voiceInput.state == .recording ? "Stop dictation" : "Start dictation"
    }

    private var voiceButtonSystemImage: String {
        switch voiceInput.state {
        case .requestingPermission, .transcribing:
            "waveform"
        case .recording:
            "stop.fill"
        case .idle:
            "mic.fill"
        }
    }

    private func showAttachmentMenu() {
        guard !voiceInput.isActive else { return }
        guard remainingAttachmentSlots > 0 else {
            showAttachmentError("Attachment limit reached")
            return
        }
        tick()
        showingAttachmentOptions = true
    }

    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            for url in urls.prefix(remainingAttachmentSlots) {
                appendFile(from: url)
            }
        case .failure:
            showAttachmentError("Could not open that file")
        }
    }

    private func appendFile(from url: URL) {
        let didAccess = url.startAccessingSecurityScopedResource()
        defer {
            if didAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }

        do {
            let data = try Data(contentsOf: url)
            let contentType = UTType(filenameExtension: url.pathExtension)

            guard validateAttachment(size: data.count) else { return }

            let file = AttachmentEncoding.fileAttachment(name: url.lastPathComponent, contentType: contentType, data: data)
            guard validateFileFitsFrame(file) else { return }
            fileAttachments.append(file)
            attachmentError = nil
            tick()
        } catch {
            showAttachmentError("Could not attach \(url.lastPathComponent)")
        }
    }

    private func validateAttachment(size: Int) -> Bool {
        guard remainingAttachmentSlots > 0 else {
            showAttachmentError("Attachment limit reached")
            return false
        }

        guard size <= maxFileSizeBytes else {
            showAttachmentError("Attachment is larger than \(formatFileSize(maxFileSizeBytes))")
            return false
        }

        return true
    }

    /// A file can pass the raw size limit yet still overflow the ~836 KB input frame once base64-encoded
    /// (files aren't downscaled like images). Reject at attach time — mirroring send()'s frame check — so
    /// the user is never left holding an attachment that can never be sent.
    private func validateFileFitsFrame(_ file: FileAttachment) -> Bool {
        // Match send()'s computation: it injects the TRIMMED prompt, so trim here too or a file that
        // would actually send fine could be rejected over trailing whitespace.
        let transmittedPrompt = CustomInstructions.injecting(
            personality: personality,
            instructions: customInstructions,
            into: text.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        let projected = AttachmentEncoding.estimatedInputFrameBytes(
            prompt: transmittedPrompt,
            images: [],
            files: fileAttachments + [file]
        )
        guard projected <= maxInputFramePayloadBytes else {
            // Blame the single file only when it overflows the frame on its own; otherwise the real
            // cause is the combined attachment payload, so use send()'s cumulative wording.
            let fileAlone = AttachmentEncoding.estimatedInputFrameBytes(prompt: "", images: [], files: [file])
            if fileAlone > maxInputFramePayloadBytes {
                showAttachmentError("“\(file.name)” is too large to send (max about \(formatFileSize(maxSingleFileRawBytes)))")
            } else {
                showAttachmentError("Message attachments are larger than \(formatFileSize(maxInputFramePayloadBytes))")
            }
            return false
        }
        return true
    }

    /// Rough largest raw file that fits one input frame on its own (base64 ≈ 4/3 expansion, plus overhead).
    private var maxSingleFileRawBytes: Int {
        max(0, (maxInputFramePayloadBytes - 4096 - 64) * 3 / 4)
    }

    private func removeFile(_ id: String) {
        fileAttachments.removeAll { $0.id == id }
        attachmentError = nil
        tick()
    }

    private func showAttachmentError(_ message: String) {
        attachmentError = message
        errorFeedbackTrigger += 1
    }

    private func toggleVoiceInput() {
        tick()
        switch voiceInput.state {
        case .recording:
            voiceInput.stopRecording()
        case .idle:
            voiceOriginalText = text // exact text (incl. trailing whitespace) for ✕ restore
            voiceSeedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            voiceLastApplied = text
            isFocused = true // keep the keyboard up; the transcript streams into the field live
            voiceInput.startRecording()
        case .requestingPermission, .transcribing:
            break
        }
    }

    private func applyVoiceTranscript(_ transcript: String) {
        guard !transcript.isEmpty else { return }
        // Only overwrite the field if the user hasn't manually edited it since our last write; otherwise
        // a streaming partial would clobber what they just typed.
        guard text == voiceLastApplied else { return }
        let separator = voiceSeedText.isEmpty ? "" : " "
        let merged = voiceSeedText + separator + transcript
        text = merged
        voiceLastApplied = merged
    }

    /// ✓ — keep the dictated text: stop recording so the final transcript settles into the field.
    private func confirmVoiceInput() {
        tick()
        if voiceInput.state == .recording {
            voiceInput.stopRecording()
        }
    }

    /// ✕ — discard the dictation and restore exactly what was in the field before recording started.
    private func cancelVoiceInput() {
        tick()
        voiceInput.cancel()
        text = voiceOriginalText
    }

    private func selectSkill(_ skill: SkillInfo) {
        tick()
        text = "/\(skill.name) "
        isFocused = true
    }

    private func send() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !isRunning, !voiceInput.isActive, !trimmed.isEmpty || hasAttachments else { return }
        tick()
        let files = fileAttachments
        let transmittedPrompt = CustomInstructions.injecting(
            personality: personality,
            instructions: customInstructions,
            into: trimmed
        )
        let estimatedFrameBytes = AttachmentEncoding.estimatedInputFrameBytes(
            prompt: transmittedPrompt,
            images: [],
            files: files
        )
        guard estimatedFrameBytes <= maxInputFramePayloadBytes else {
            showAttachmentError("Message attachments are larger than \(formatFileSize(maxInputFramePayloadBytes))")
            return
        }

        text = ""
        fileAttachments = []
        attachmentError = nil
        isFocused = false
        onSend(trimmed, [], files)
    }

    private func stop() {
        tick()
        onStop()
    }

    private func tick() {
        feedbackTrigger += 1
    }
}


#Preview("Chat Input Ready") {
    ChatInputBar(
        placeholder: "Message OpenOnion",
        isRunning: false,
        acceptedInputs: PreviewFixtures.sampleAgentInfo.acceptedInputs,
        skills: PreviewFixtures.sampleSkills,
        onSend: { _, _, _ in },
        onStop: {}
    )
    .padding()
}

#Preview("Chat Input Running") {
    ChatInputBar(
        placeholder: "Message OpenOnion",
        isRunning: true,
        acceptedInputs: PreviewFixtures.sampleAgentInfo.acceptedInputs,
        skills: PreviewFixtures.sampleSkills,
        onSend: { _, _, _ in },
        onStop: {}
    )
    .padding()
}
