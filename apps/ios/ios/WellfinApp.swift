//
//  WellfinApp.swift
//  wellfin
//
//  Created by Yu Mabuchi on 2025/11/03.
//

import SwiftUI

@main
struct WellfinApp: App {
    @State private var preferences = UserPreferences.shared
    
    init() {
        // Configure global appearance at app launch
        AppAppearance.configure()
        
        // Load user preferences on launch
        // Preferences are automatically loaded via UserPreferences.shared initialization
        _ = UserPreferences.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .applyGlobalAppearance()
                .environment(preferences)
        }
    }
}
