//
//  TransactionsView.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import SwiftUI

struct TransactionsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Transactions")
                    .font(.largeTitle)
                    .padding()
                
                Text("Browse and filter transactions")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Transactions")
        }
    }
}

#Preview {
    TransactionsView()
}

