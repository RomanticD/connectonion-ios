//
//  AttachmentSheet.swift
//
//  Purpose: Presents the composer file-attachment action.
//
//  This file is part of the ConnectOnion iOS application.
//
import SwiftUI
import UIKit

/// The composer's attachment sheet. Files are the only supported new attachment type; photo-library
/// and camera capture remain intentionally unavailable from chat.
struct AttachmentSheet: View {
    var onFiles: () -> Void

    @Environment(\.dismiss) private var dismiss

    private let tileColor = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(white: 0.17, alpha: 1)
            : UIColor(white: 0.925, alpha: 1)
    })

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            addFilesRow
                .padding(.horizontal, 16)
            Spacer(minLength: 0)
        }
        .padding(.bottom, 8)
        .presentationDetents([.height(154)])
        .presentationDragIndicator(.visible)
        .presentationBackground(Color(.systemBackground))
    }

    private var header: some View {
        ZStack {
            Text("Add to Chat")
                .appFont(.headline)

            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .appFont(.body, weight: .semibold)
                        .foregroundStyle(.primary)
                        .frame(width: 36, height: 36)
                        .background(Color(.systemBackground), in: .circle)
                        .overlay(Circle().stroke(Color(.systemGray4), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close")

                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 8)
    }

    private var addFilesRow: some View {
        Button {
            dismiss()
            onFiles()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "doc")
                    .appFont(.body)
                    .frame(width: 24)
                Text("Add files")
                    .appFont(.body)
                Spacer(minLength: 0)
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(tileColor, in: .rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(AccessibilityID.chatAttachmentFilesButton)
    }
}
