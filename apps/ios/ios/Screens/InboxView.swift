//
//  InboxView.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import SwiftUI

struct InboxView: View {
    var body: some View {
        VStack {
            Text("Inbox")
                .font(.largeTitle)
                .padding()
            
            Text("Transaction triage and classification")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Inbox")
    }
}

#Preview {
    NavigationStack {
        InboxView()
    }
}



