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
    @State private var showingResetConfirmation = false
    
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
            
            Section("Demo Mode") {
                Picker("Dataset", selection: $preferences.selectedDataset) {
                    Text("Dataset A").tag("A")
                    Text("Dataset B").tag("B")
                }
                .onChange(of: preferences.selectedDataset) { _, _ in
                    // Dataset change will be reflected via MockData.currentProvider
                    // UI will update when views refresh
                }
            }
            
            Section("Data Management") {
                Button("Reset Data", role: .destructive) {
                    showingResetConfirmation = true
                }
                .alert("Reset Data", isPresented: $showingResetConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Reset", role: .destructive) {
                        resetDataToDefaults()
                    }
                } message: {
                    Text("This will restore demo data to defaults. This action cannot be undone.")
                }
            }
            
            Section {
                Button("Reset Preferences to Defaults", role: .destructive) {
                    preferences.resetToDefaults()
                }
            }
        }
        .navigationTitle("Settings")
    }
    
    /// Resets demo data to defaults by resetting dataset selection
    private func resetDataToDefaults() {
        // Reset dataset to default (A)
        preferences.selectedDataset = "A"
        
        // Note: In a real implementation, this would also reset any cached data
        // For MVP, resetting the dataset selection is sufficient
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environment(UserPreferences.shared)
    }
}



