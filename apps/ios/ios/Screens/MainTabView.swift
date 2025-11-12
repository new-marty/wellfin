//
//  MainTabView.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case inbox = "Inbox"
    case transactions = "Transactions"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .inbox:
            return "tray.fill"
        case .transactions:
            return "list.bullet"
        case .settings:
            return "gearshape.fill"
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .home:
            HomeView()
        case .inbox:
            InboxView()
        case .transactions:
            TransactionsView()
        case .settings:
            SettingsView()
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @State private var inboxBadgeCount: Int? = nil // Stub for badge support
    
    // Navigation paths for each tab to preserve state independently
    @State private var homeNavigationPath = NavigationPath()
    @State private var inboxNavigationPath = NavigationPath()
    @State private var transactionsNavigationPath = NavigationPath()
    @State private var settingsNavigationPath = NavigationPath()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                NavigationStack(path: navigationPath(for: tab)) {
                    Group {
                        if tab == .inbox, let count = inboxBadgeCount {
                            tab.view.badge(count)
                        } else {
                            tab.view
                        }
                    }
                }
                .tabItem {
                    Label(tab.rawValue, systemImage: tab.icon)
                }
                .tag(tab)
            }
        }
        .tint(nil) // Use system tint
        .onOpenURL { url in
            handleDeepLink(url)
        }
    }
    
    // MARK: - Navigation Path Management
    
    /// Returns the appropriate navigation path binding for the given tab
    private func navigationPath(for tab: Tab) -> Binding<NavigationPath> {
        switch tab {
        case .home:
            return $homeNavigationPath
        case .inbox:
            return $inboxNavigationPath
        case .transactions:
            return $transactionsNavigationPath
        case .settings:
            return $settingsNavigationPath
        }
    }
    
    /// Returns the current navigation path for the selected tab
    private var currentNavigationPath: Binding<NavigationPath> {
        navigationPath(for: selectedTab)
    }
    
    // MARK: - Deep Link Routing
    
    /// Handles deep links to route to correct tab and push appropriate view
    /// Supports both tab-level navigation and pushing views within tabs
    private func handleDeepLink(_ url: URL) {
        // Example: wellfin://home, wellfin://inbox, wellfin://transactions, wellfin://settings
        // Example: wellfin://transactions/123 (pushes transaction detail)
        guard url.scheme == "wellfin" else { return }
        
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        let tabName = url.host ?? pathComponents.first ?? ""
        
        // Switch to the appropriate tab
        switch tabName {
        case "home":
            selectedTab = .home
            // Handle nested paths if needed (e.g., wellfin://home/detail)
            if pathComponents.count > 1 {
                // Future: push specific views within home tab
            }
        case "inbox":
            selectedTab = .inbox
            if pathComponents.count > 1 {
                // Future: push specific views within inbox tab
            }
        case "transactions":
            selectedTab = .transactions
            if pathComponents.count > 1 {
                let transactionId = pathComponents[1]
                // Future: push transaction detail view
                // transactionsNavigationPath.append(transactionId)
            }
        case "settings":
            selectedTab = .settings
            if pathComponents.count > 1 {
                // Future: push specific settings screens
            }
        default:
            break
        }
    }
}

#Preview("Light Mode") {
    MainTabView()
        .previewAppearance(colorScheme: .light)
}

#Preview("Dark Mode") {
    MainTabView()
        .previewAppearance(colorScheme: .dark)
}

#Preview("Large Text") {
    MainTabView()
        .previewAppearance(sizeCategory: .accessibilityExtraExtraExtraLarge)
}

