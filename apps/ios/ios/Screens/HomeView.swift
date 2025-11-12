//
//  HomeView.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Home")
                    .font(.largeTitle)
                    .padding()
                
                Text("Safe-to-Spend and next best actions")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}

