//
//  SettingsView.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import SwiftUI

struct SettingsView: View {
    @Environment(UserPreferences.self) private var preferences
    
    var body: some View {
        SettingsViewContent(preferences: preferences)
    }
}

private struct SettingsViewContent: View {
    @Bindable var preferences: UserPreferences
    
    var body: some View {
        Form {
            Section("Preferences") {
                Toggle("Show Notifications", isOn: $preferences.showNotifications)
                Toggle("Use Demo Dataset", isOn: $preferences.demoDataset)
                Toggle("Reduce Motion", isOn: $preferences.reduceMotion)
            }
            
            Section("Formatting") {
                Picker("Currency Format", selection: $preferences.currencyFormat) {
                    Text("JPY (¥)").tag("JPY")
                    Text("USD ($)").tag("USD")
                    Text("EUR (€)").tag("EUR")
                }
                
                Picker("Date Format", selection: $preferences.dateFormat) {
                    Text("MM/dd/yyyy").tag("MM/dd/yyyy")
                    Text("yyyy-MM-dd").tag("yyyy-MM-dd")
                    Text("dd/MM/yyyy").tag("dd/MM/yyyy")
                }
            }
            
            Section("Japanese Formatting") {
                Toggle("Use JPY Display (¥)", isOn: $preferences.useJPYDisplay)
                
                Toggle("Use yyyy-mm-dd Date Format", isOn: $preferences.useYYYYMMDDDateFormat)
                
                Toggle("Monday Week Start", isOn: $preferences.mondayWeekStart)
            }
            
            Section {
                Button("Reset to Defaults", role: .destructive) {
                    preferences.resetToDefaults()
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environment(UserPreferences.shared)
    }
}



