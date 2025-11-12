//
//  HomeView.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import SwiftUI

struct HomeView: View {
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
                    Text("Failed to load")
                        .font(.headline)
                    Text("Please try again")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .empty:
                VStack(spacing: 16) {
                    Image(systemName: "house")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("Welcome to Wellfin")
                        .font(.headline)
                    Text("Get started by adding your first account")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .default, .none:
                VStack {
                    Text("Home")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Safe-to-Spend and next best actions")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Home")
    }
}

// MARK: - Previews

#Preview("Default") {
    NavigationStack {
        HomeView(previewState: .default)
    }
}

#Preview("Empty") {
    NavigationStack {
        HomeView(previewState: .empty)
    }
}

#Preview("Loading") {
    NavigationStack {
        HomeView(previewState: .loading)
    }
}

#Preview("Error") {
    NavigationStack {
        HomeView(previewState: .error)
    }
}

#Preview("Light Mode") {
    NavigationStack {
        HomeView(previewState: .default)
            .previewAppearance(colorScheme: .light)
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        HomeView(previewState: .default)
            .previewAppearance(colorScheme: .dark)
    }
}



