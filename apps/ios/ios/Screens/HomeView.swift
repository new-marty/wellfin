//
//  HomeView.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import SwiftUI

struct HomeView: View {
    @State private var screenStateManager = ScreenStateManager.shared
    @Environment(UserPreferences.self) private var preferences
    
    private var currentState: ScreenState {
        screenStateManager.state(for: .home)
    }
    
    var body: some View {
        Group {
            switch currentState {
            case .default:
                HomeContentView()
            case .empty:
                EmptyStateView(
                    title: "No Data Available",
                    message: "Start by adding your first transaction or connecting an account to see your Safe-to-Spend and suggestions.",
                    actionTitle: "Add Transaction",
                    action: {}
                )
            case .loading:
                LoadingStateView()
            case .error:
                ErrorStateView(
                    title: "Unable to Load",
                    message: "Something went wrong while loading your home data. Please try again.",
                    retryAction: {
                        screenStateManager.setState(.default, for: .home)
                    }
                )
            }
        }
        .navigationTitle("Home")
    }
}

private struct HomeContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: SpacingToken.lg) {
                Text("Home")
                    .font(.largeTitle)
                    .padding()
                
                Text("Safe-to-Spend and next best actions")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

#Preview("Default") {
    NavigationStack {
        HomeView()
            .environment(UserPreferences.shared)
    }
}

#Preview("Empty") {
    NavigationStack {
        HomeView()
            .environment(UserPreferences.shared)
            .onAppear {
                ScreenStateManager.shared.setState(.empty, for: .home)
            }
    }
}

#Preview("Loading") {
    NavigationStack {
        HomeView()
            .environment(UserPreferences.shared)
            .onAppear {
                ScreenStateManager.shared.setState(.loading, for: .home)
            }
    }
}

#Preview("Error") {
    NavigationStack {
        HomeView()
            .environment(UserPreferences.shared)
            .onAppear {
                ScreenStateManager.shared.setState(.error, for: .home)
            }
    }
}



