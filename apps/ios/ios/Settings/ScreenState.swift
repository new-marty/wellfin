//
//  ScreenState.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Screen state management for runtime toggles (default/empty/loading/error)

import Foundation

/// Represents the possible states a screen can be in
enum ScreenState: String, CaseIterable {
    case `default` = "default"
    case empty = "empty"
    case loading = "loading"
    case error = "error"
    
    var displayName: String {
        switch self {
        case .default:
            return "Default"
        case .empty:
            return "Empty"
        case .loading:
            return "Loading"
        case .error:
            return "Error"
        }
    }
}

/// Screen identifier for state management
enum ScreenIdentifier: String, CaseIterable {
    case home = "home"
    case inbox = "inbox"
    case transactions = "transactions"
    case tagging = "tagging"
    
    var displayName: String {
        switch self {
        case .home:
            return "Home"
        case .inbox:
            return "Inbox"
        case .transactions:
            return "Transactions"
        case .tagging:
            return "Tagging"
        }
    }
}

/// Manages screen states for runtime toggles
@Observable
final class ScreenStateManager {
    static let shared = ScreenStateManager()
    
    private let userDefaults: UserDefaults
    
    // Screen state storage
    private var screenStates: [ScreenIdentifier: ScreenState] = [:]
    
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadStates()
    }
    
    // MARK: - State Management
    
    /// Gets the current state for a screen
    func state(for screen: ScreenIdentifier) -> ScreenState {
        screenStates[screen] ?? .default
    }
    
    /// Sets the state for a screen
    func setState(_ state: ScreenState, for screen: ScreenIdentifier) {
        screenStates[screen] = state
        saveState(state, for: screen)
    }
    
    /// Resets all screen states to default
    func resetAllToDefault() {
        for screen in ScreenIdentifier.allCases {
            setState(.default, for: screen)
        }
    }
    
    /// Resets a specific screen to default
    func resetToDefault(for screen: ScreenIdentifier) {
        setState(.default, for: screen)
    }
    
    // MARK: - Persistence
    
    private func loadStates() {
        for screen in ScreenIdentifier.allCases {
            let key = stateKey(for: screen)
            if let rawValue = userDefaults.string(forKey: key),
               let state = ScreenState(rawValue: rawValue) {
                screenStates[screen] = state
            } else {
                screenStates[screen] = .default
            }
        }
    }
    
    private func saveState(_ state: ScreenState, for screen: ScreenIdentifier) {
        let key = stateKey(for: screen)
        userDefaults.set(state.rawValue, forKey: key)
        userDefaults.synchronize()
    }
    
    private func stateKey(for screen: ScreenIdentifier) -> String {
        "screenState.\(screen.rawValue)"
    }
}


