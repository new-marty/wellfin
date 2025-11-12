//
//  WellfinApp.swift
//  wellfin
//
//  Created by Yu Mabuchi on 2025/11/03.
//

import SwiftUI

@main
struct WellfinApp: App {
    init() {
        // Configure global appearance at app launch
        AppAppearance.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .applyGlobalAppearance()
        }
    }
}
