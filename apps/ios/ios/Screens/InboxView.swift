//
//  InboxView.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import SwiftUI

struct InboxView: View {
    /// Preview state for testing different UI states
    private let previewState: PreviewState?
    
    /// Initializer for normal use
    init() {
        self.previewState = nil
    }
    
    /// Initializer for previews with specific state
    init(previewState: PreviewState) {
        self.previewState = previewState
    }
    
    var body: some View {
        Group {
            switch previewState {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .error:
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("Failed to load inbox")
                        .font(.headline)
                    Text("Please try again")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .empty:
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("Inbox is empty")
                        .font(.headline)
                    Text("All transactions have been processed")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .default, .none:
                VStack {
                    Text("Inbox")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Transaction triage and classification")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Inbox")
    }
}

// MARK: - Previews

#Preview("Default") {
    NavigationStack {
        InboxView(previewState: .default)
    }
}

#Preview("Empty") {
    NavigationStack {
        InboxView(previewState: .empty)
    }
}

#Preview("Loading") {
    NavigationStack {
        InboxView(previewState: .loading)
    }
}

#Preview("Error") {
    NavigationStack {
        InboxView(previewState: .error)
    }
}

#Preview("Light Mode") {
    NavigationStack {
        InboxView(previewState: .default)
            .previewAppearance(colorScheme: .light)
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        InboxView(previewState: .default)
            .previewAppearance(colorScheme: .dark)
    }
}



