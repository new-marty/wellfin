//
//  DebugMenuView.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  In-app debug menu for toggling screen states and datasets (debug builds only)

import SwiftUI

#if DEBUG
struct DebugMenuView: View {
    @State private var screenStateManager = ScreenStateManager.shared
    @State private var userPreferences = UserPreferences.shared
    @State private var selectedDataset: DatasetVariant = .datasetA
    @State private var customSeed: String = "12345"
    @State private var showResetConfirmation = false
    
    var body: some View {
        NavigationStack {
            Form {
                // Screen States Section
                Section("Screen States") {
                    ForEach(ScreenIdentifier.allCases, id: \.self) { screen in
                        Picker(screen.displayName, selection: Binding(
                            get: { screenStateManager.state(for: screen) },
                            set: { screenStateManager.setState($0, for: screen) }
                        )) {
                            ForEach(ScreenState.allCases, id: \.self) { state in
                                Text(state.displayName).tag(state)
                            }
                        }
                    }
                }
                
                // Dataset Section
                Section("Mock Dataset") {
                    Picker("Dataset", selection: $selectedDataset) {
                        ForEach(DatasetVariant.allCases, id: \.self) { variant in
                            Text(variant.rawValue).tag(variant)
                        }
                    }
                    .onChange(of: selectedDataset) { _, newValue in
                        // Update user preferences with dataset selection
                        // This will be used by MockDataProvider
                    }
                    
                    HStack {
                        Text("Custom Seed")
                        Spacer()
                        TextField("Seed", text: $customSeed)
                            .keyboardType(.numberPad)
                            .frame(width: 100)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                // Current State Display
                Section("Current State") {
                    ForEach(ScreenIdentifier.allCases, id: \.self) { screen in
                        HStack {
                            Text(screen.displayName)
                            Spacer()
                            Text(screenStateManager.state(for: screen).displayName)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    HStack {
                        Text("Dataset")
                        Spacer()
                        Text(selectedDataset.rawValue)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Seed")
                        Spacer()
                        Text(customSeed)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Reset Section
                Section {
                    Button(role: .destructive, action: {
                        showResetConfirmation = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Reset to Defaults")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Debug Menu")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Reset to Defaults", isPresented: $showResetConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    resetToDefaults()
                }
            } message: {
                Text("This will reset all screen states and dataset settings to their default values.")
            }
        }
    }
    
    private func resetToDefaults() {
        screenStateManager.resetAllToDefault()
        selectedDataset = .datasetA
        customSeed = "12345"
    }
}

#Preview {
    DebugMenuView()
}
#endif

