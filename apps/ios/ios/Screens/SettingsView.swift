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
            // Accounts Section (stub)
            Section("Accounts") {
                HStack {
                    Text("Manage Accounts")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    // Stub - would navigate to accounts management
                }
                .accessibilityLabel("Manage Accounts")
                .accessibilityHint("Tap to manage your accounts")
            }
            
            // Notifications Section (stub)
            Section("Notifications") {
                Toggle("Show Notifications", isOn: $preferences.showNotifications)
                    .accessibilityLabel("Show Notifications")
                    .accessibilityHint("Enable or disable notifications")
                
                HStack {
                    Text("Notification Settings")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    // Stub - would navigate to notification settings
                }
                .accessibilityLabel("Notification Settings")
            }
            
            // Privacy Section (stub)
            Section("Privacy") {
                HStack {
                    Text("Privacy Policy")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    // Stub - would open privacy policy
                }
                .accessibilityLabel("Privacy Policy")
                
                HStack {
                    Text("Data Management")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    // Stub - would navigate to data management
                }
                .accessibilityLabel("Data Management")
            }
            
            // Preferences Section (functional)
            Section("Preferences") {
                Toggle("Use Demo Dataset", isOn: $preferences.demoDataset)
                    .accessibilityLabel("Use Demo Dataset")
                    .accessibilityHint("Toggle to use demo data for testing")
                
                Toggle("Reduce Motion", isOn: $preferences.reduceMotion)
                    .accessibilityLabel("Reduce Motion")
                    .accessibilityHint("Reduce animations for accessibility")
                
                Picker("Currency Format", selection: $preferences.currencyFormat) {
                    Text("JPY (¥)").tag("JPY")
                    Text("USD ($)").tag("USD")
                    Text("EUR (€)").tag("EUR")
                }
                .accessibilityLabel("Currency Format")
                
                Picker("Date Format", selection: $preferences.dateFormat) {
                    Text("MM/dd/yyyy").tag("MM/dd/yyyy")
                    Text("yyyy-MM-dd").tag("yyyy-MM-dd")
                    Text("dd/MM/yyyy").tag("dd/MM/yyyy")
                }
                .accessibilityLabel("Date Format")
            }
            
            Section("Japanese Formatting") {
                Toggle("Use JPY Display (¥)", isOn: $preferences.useJPYDisplay)
                    .accessibilityLabel("Use JPY Display")
                    .accessibilityHint("Display currency using Japanese yen format")
                
                Toggle("Use yyyy-mm-dd Date Format", isOn: $preferences.useYYYYMMDDDateFormat)
                    .accessibilityLabel("Use yyyy-mm-dd Date Format")
                    .accessibilityHint("Use ISO 8601 date format")
                
                Toggle("Monday Week Start", isOn: $preferences.mondayWeekStart)
                    .accessibilityLabel("Monday Week Start")
                    .accessibilityHint("Start the week on Monday instead of Sunday")
            }
            
            Section {
                Button("Reset to Defaults", role: .destructive) {
                    preferences.resetToDefaults()
                }
                .accessibilityLabel("Reset to Defaults")
                .accessibilityHint("Reset all preferences to their default values")
            }
            
            #if DEBUG
            Section("Debug") {
                NavigationLink("Debug Menu") {
                    DebugMenuView()
                }
            }
            #endif
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



