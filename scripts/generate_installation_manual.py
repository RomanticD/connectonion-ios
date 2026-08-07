#!/usr/bin/env python3
"""Generate the assessor-facing installation-manual PDF from verified repository facts."""

from pathlib import Path

from reportlab.lib.colors import HexColor
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import cm
from reportlab.platypus import Image, KeepTogether, Paragraph, SimpleDocTemplate, Spacer


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "docs" / "INSTALLATION_MANUAL.pdf"
SIMULATOR_SCREENSHOT = ROOT / "docs" / "assets" / "installation-manual" / "simulator-home.png"


def paragraph(text: str, style: ParagraphStyle) -> Paragraph:
    return Paragraph(text, style)


def main() -> None:
    styles = getSampleStyleSheet()
    styles.add(ParagraphStyle(
        name="ManualTitle", parent=styles["Title"], fontName="Helvetica-Bold",
        fontSize=22, leading=27, alignment=TA_CENTER, textColor=HexColor("#312A4D"),
        spaceAfter=8,
    ))
    styles.add(ParagraphStyle(
        name="ManualSubtitle", parent=styles["Normal"], fontSize=10, leading=14,
        alignment=TA_CENTER, textColor=HexColor("#5A5170"), spaceAfter=20,
    ))
    styles.add(ParagraphStyle(
        name="ManualHeading", parent=styles["Heading2"], fontName="Helvetica-Bold",
        fontSize=14, leading=18, textColor=HexColor("#4C3A7A"), spaceBefore=12,
        spaceAfter=6,
    ))
    styles.add(ParagraphStyle(
        name="ManualBody", parent=styles["BodyText"], fontSize=9.5, leading=12.8,
        spaceAfter=7,
    ))
    styles.add(ParagraphStyle(
        name="ManualCode", parent=styles["Code"], fontName="Courier", fontSize=9,
        leading=13, leftIndent=12, backColor=HexColor("#F4F1F8"),
        borderColor=HexColor("#DDD5E9"), borderWidth=0.5, borderPadding=7,
        spaceBefore=3, spaceAfter=9,
    ))

    body = styles["ManualBody"]
    story = [
        paragraph("ConnectOnion iOS", styles["ManualTitle"]),
        paragraph("COMP9900 Software Quality - Installation Manual", styles["ManualSubtitle"]),
        paragraph("1. What is included", styles["ManualHeading"]),
        paragraph(
            "The submission ZIP contains the SwiftUI app, WidgetKit extension, unit and UI tests, "
            "test fixtures, GitHub Actions workflows, documentation, and an optional real-agent "
            "E2E helper. The ConnectOnion agent runtime and public relay are external services; "
            "the app can still be built and explored using its mock UI test mode without them.", body),
        paragraph("2. Prerequisites", styles["ManualHeading"]),
        paragraph(
            "- macOS with Xcode 26 and the iOS 26 SDK.<br/>"
            "- An iOS 26 Simulator (an iPhone simulator is sufficient), or an appropriately signed physical iPhone.<br/>"
            "- Internet access for Swift Package Manager to resolve the pinned packages on the first build.", body),
        paragraph(
            "<b>Docker arrangement.</b> Docker is not applicable: this is a native iOS application "
            "that must run in an iOS simulator or on a device. The project should be assessed using "
            "the steps below, consistent with the assessment specification's mobile-app exception.", body),
        paragraph("3. Build and run", styles["ManualHeading"]),
        paragraph(
            "1. Unzip the submission and open <font name=\"Courier\">ConnectOnion iOS.xcodeproj</font> in Xcode 26.<br/>"
            "2. Allow Swift Package Manager to resolve the pinned dependencies.<br/>"
            "3. Select the <font name=\"Courier\">ConnectOnion iOS</font> scheme.<br/>"
            "4. Select an iOS 26 iPhone simulator.<br/>"
            "5. Build and run (Cmd+R).", body),
        paragraph(
            "The first-run screen provides an Add Agent action. For a live interaction, enter a reachable "
            "ConnectOnion agent address and endpoint. A local agent on a physical iPhone must use the "
            "host machine's LAN address rather than localhost; the phone and host must be mutually reachable.", body),
        paragraph("Running on a physical iPhone", styles["Heading3"]),
        paragraph(
            "1. Connect the iPhone by cable or enable wireless debugging, then select it in Xcode's run-destination menu.<br/>"
            "2. Select the <b>ConnectOnion iOS</b> scheme and press the Run button (the play icon) or use Cmd+R.<br/>"
            "3. If iOS blocks the first launch, on the phone open <b>Settings &gt; General &gt; VPN &amp; Device Management</b>, "
            "select the developer/team entry, then tap <b>Trust</b>. Return to Xcode and run again.", body),
        paragraph(
            "This trust action is only required for a development-signed physical device; the iOS Simulator does not "
            "require it. The selected Apple account/team must be authorised to sign the bundle identifier configured in "
            "the Xcode project.", body),
        paragraph("Example simulator result", styles["Heading3"]),
        paragraph(
            "The following screenshot was captured after building and running the submitted app on an iPhone 17 Pro "
            "Simulator. It shows the initial agent list and the New Agent entry point.", body),
        Image(str(SIMULATOR_SCREENSHOT), width=2.4 * cm, height=5.22 * cm, hAlign="CENTER"),
        Spacer(1, 5),
        paragraph("4. Assessment paths", styles["ManualHeading"]),
        KeepTogether([
            paragraph("Mock UI path (no external agent required)", styles["Heading3"]),
            paragraph(
                "Run the UI tests in Xcode with Cmd+U. The app uses deterministic seeded, in-memory data "
                "when launched with <font name=\"Courier\">--ui-testing</font>; this exercises chat rendering, "
                "streaming state, agent and conversation management, approvals, questions, onboarding, plan "
                "review, and navigation without external services.", body),
        ]),
        KeepTogether([
            paragraph("Live-agent path (optional)", styles["Heading3"]),
            paragraph("For a real protocol round trip, see <font name=\"Courier\">scripts/README.md</font> and run:", body),
            paragraph("./scripts/run_e2e.sh", styles["ManualCode"]),
            paragraph(
                "This requires Xcode 26, connectonion&gt;=1.5.3, and a ConnectOnion identity/API key created "
                "by <font name=\"Courier\">co auth</font>. The helper starts a local test agent, drives the app "
                "through a signed WebSocket session, and cleans up afterwards.", body),
        ]),
        paragraph("5. Testing evidence", styles["ManualHeading"]),
        paragraph(
            "The <font name=\"Courier\">ConnectOnion iOSTests</font> target covers protocol encoding/decoding, "
            "address validation, direct and relay routing, event reduction, error/retry behaviour, agent QR "
            "payloads, persistence/session handling, attachments, personalisation, and markdown rendering. "
            "<font name=\"Courier\">ConnectOnion iOSUITests</font> covers seeded and empty launches, streaming "
            "chat, editing/regeneration, agent and conversation CRUD, and interactive workflow cards.", body),
        paragraph(
            "GitHub Actions runs the unit and UI suite on every push via "
            "<font name=\"Courier\">.github/workflows/ios-tests.yml</font>. The live-agent E2E test is intentionally "
            "separate because it depends on external credentials and a compatible runtime.", body),
        paragraph("6. Limitations and troubleshooting", styles["ManualHeading"]),
        paragraph(
            "- The app is a client, not an agent host: a live conversation requires a compatible remote agent.<br/>"
            "- The public relay/directory is external to this repository; its availability is outside the app's control.<br/>"
            "- On a simulator, camera capture is unavailable; use the photo-based QR fallback. On a physical device, grant relevant permissions when prompted.<br/>"
            "- If a local physical-device connection fails, confirm firewall, LAN reachability, the /info endpoint, and the WebSocket endpoint. University, guest, VPN, and client-isolated Wi-Fi can block peer-to-peer access.", body),
        paragraph(
            "A completion indication after the app has been fully closed and a dedicated iPad layout are recorded as "
            "assessed follow-up work, not confirmed delivery commitments. The main iPhone flow remains the supported "
            "assessment path.", body),
        paragraph(
            "For detailed architecture, security considerations, release checks, and a complete troubleshooting guide, "
            "see <font name=\"Courier\">docs/CLIENT_HANDOVER.md</font> in the submitted ZIP.", body),
        Spacer(1, 6),
        paragraph("Prepared from the repository documentation for the submitted source revision.", styles["ManualSubtitle"]),
    ]

    document = SimpleDocTemplate(
        str(OUTPUT), pagesize=A4, leftMargin=2.1 * cm, rightMargin=2.1 * cm,
        topMargin=1.8 * cm, bottomMargin=1.8 * cm, title="ConnectOnion iOS Installation Manual",
        author="ConnectOnion iOS Team",
    )
    document.build(story)
    print(OUTPUT)


if __name__ == "__main__":
    main()
