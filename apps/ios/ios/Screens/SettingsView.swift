//
//  SettingsView.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .padding()
                
                Text("Manage accounts, notifications, privacy, and preferences")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}

