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
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Group {
                    if tab == .inbox, let count = inboxBadgeCount {
                        tab.view.badge(count)
                    } else {
                        tab.view
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
            // Deep link routing stub
            handleDeepLink(url)
        }
    }
    
    // MARK: - Deep Link Routing (Stub)
    /// Handles deep links to route to correct tab and push appropriate view
    /// Stub implementation - actual routing logic to be implemented later
    private func handleDeepLink(_ url: URL) {
        // Example: wellfin://home, wellfin://inbox, wellfin://transactions, wellfin://settings
        guard url.scheme == "wellfin" else { return }
        
        let path = url.host ?? url.pathComponents.first ?? ""
        
        switch path {
        case "home":
            selectedTab = .home
        case "inbox":
            selectedTab = .inbox
        case "transactions":
            selectedTab = .transactions
        case "settings":
            selectedTab = .settings
        default:
            break
        }
        
        // TODO: Handle pushing specific views within tabs (e.g., wellfin://transactions/123)
        // This will be implemented when navigation stacks are added per tab (NM-16)
    }
}

#Preview {
    MainTabView()
}

