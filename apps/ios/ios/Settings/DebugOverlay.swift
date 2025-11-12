//
//  DebugOverlay.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Debug overlay for rapid in-app exploration of states and latency simulation (debug builds only)

import SwiftUI

#if DEBUG
/// Latency simulator that delays view model updates
@Observable
final class LatencySimulator {
    static let shared = LatencySimulator()
    
    private(set) var delay: TimeInterval = 0.0 // 0-2 seconds
    
    private init() {}
    
    func setDelay(_ delay: TimeInterval) {
        self.delay = max(0, min(2.0, delay)) // Clamp between 0-2s
    }
    
    /// Applies latency delay to an async operation
    func applyDelay<T>(_ operation: @escaping () async -> T) async -> T {
        if delay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        return await operation()
    }
    
    /// Applies latency delay to a synchronous operation
    func applyDelay<T>(_ operation: @escaping () -> T) async -> T {
        if delay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        return operation()
    }
}

/// Debug overlay view that floats over the app
struct DebugOverlayView: View {
    @State private var screenStateManager = ScreenStateManager.shared
    @State private var latencySimulator = LatencySimulator.shared
    @State private var userPreferences = UserPreferences.shared
    @State private var isVisible = false
    @State private var selectedScreen: ScreenIdentifier = .home
    @State private var selectedState: ScreenState = .default
    @State private var latencyValue: Double = 0.0
    @State private var dataset: DatasetVariant = .datasetA
    @State private var seed: String = "12345"
    
    var body: some View {
        ZStack {
            // Invisible button to toggle overlay (top-right corner)
            if !isVisible {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                isVisible = true
                            }
                        }) {
                            Image(systemName: "bug.fill")
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(Color.blue.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .padding()
                        .accessibilityLabel("Debug Overlay")
                        .accessibilityHint("Long press or tap to open debug overlay")
                        .onLongPressGesture(minimumDuration: 0.5) {
                            withAnimation {
                                isVisible = true
                            }
                        }
                    }
                    Spacer()
                }
            }
            
            // Overlay panel
            if isVisible {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isVisible = false
                        }
                    }
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Debug Overlay")
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            withAnimation {
                                isVisible = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    
                    Divider()
                    
                    // Content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Screen State Toggles
                            Section {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Screen States")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    
                                    ForEach(ScreenIdentifier.allCases, id: \.self) { screen in
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(screen.displayName)
                                                .font(.caption)
                                            
                                            Picker("", selection: Binding(
                                                get: { screenStateManager.state(for: screen) },
                                                set: { newState in
                                                    screenStateManager.setState(newState, for: screen)
                                                    logInfo("State changed: \(screen.displayName) -> \(newState.displayName)", category: "DebugOverlay")
                                                }
                                            )) {
                                                ForEach(ScreenState.allCases, id: \.self) { state in
                                                    Text(state.displayName).tag(state)
                                                }
                                            }
                                            .pickerStyle(.segmented)
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                            
                            // Latency Simulator
                            Section {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Latency Simulator")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text("Delay: \(String(format: "%.1f", latencyValue))s")
                                                .font(.caption)
                                            Spacer()
                                            Text("(0-2s)")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                        
                                        Slider(value: $latencyValue, in: 0...2, step: 0.1) { _ in
                                            latencySimulator.setDelay(latencyValue)
                                            logInfo("Latency set to \(String(format: "%.1f", latencyValue))s", category: "DebugOverlay")
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                            
                            // Current State Display
                            Section {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Current State")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        ForEach(ScreenIdentifier.allCases, id: \.self) { screen in
                                            HStack {
                                                Text(screen.displayName)
                                                    .font(.caption)
                                                Spacer()
                                                Text(screenStateManager.state(for: screen).displayName)
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                        
                                        HStack {
                                            Text("Dataset")
                                                .font(.caption)
                                            Spacer()
                                            Text(dataset.rawValue)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        
                                        HStack {
                                            Text("Seed")
                                                .font(.caption)
                                            Spacer()
                                            Text(seed)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        
                                        HStack {
                                            Text("Latency")
                                                .font(.caption)
                                            Spacer()
                                            Text("\(String(format: "%.1f", latencyValue))s")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                            
                            // Reset Button
                            Button(action: {
                                resetToDefaults()
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Reset to Defaults")
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .foregroundStyle(.red)
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                    .background(Color(.systemBackground))
                }
                .frame(maxWidth: 400)
                .frame(maxHeight: 600)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding()
            }
        }
    }
    
    private func resetToDefaults() {
        screenStateManager.resetAllToDefault()
        latencySimulator.setDelay(0)
        latencyValue = 0
        dataset = .datasetA
        seed = "12345"
        logInfo("Reset to defaults", category: "DebugOverlay")
    }
}

/// View modifier to add debug overlay
struct DebugOverlayModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topTrailing) {
                DebugOverlayView()
            }
    }
}

extension View {
    /// Adds debug overlay (debug builds only)
    func debugOverlay() -> some View {
        #if DEBUG
        modifier(DebugOverlayModifier())
        #else
        self
        #endif
    }
}

#Preview {
    ContentView()
        .debugOverlay()
}
#endif

