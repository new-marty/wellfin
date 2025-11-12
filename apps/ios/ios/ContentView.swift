//
//  ContentView.swift
//  wellfin
//
//  Created by Yu Mabuchi on 2025/11/03.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
            #if DEBUG
            .overlay(alignment: .topTrailing) {
                DebugOverlayView()
            }
            #endif
    }
}


