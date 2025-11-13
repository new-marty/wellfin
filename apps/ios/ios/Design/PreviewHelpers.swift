//
//  PreviewHelpers.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Preview helpers for SwiftUI previews with stable seeds and state variants

import SwiftUI

/// Preview state variants for testing different UI states
enum PreviewState: String, CaseIterable {
    case `default` = "Default"
    case empty = "Empty"
    case loading = "Loading"
    case error = "Error"
    
    var displayName: String {
        rawValue
    }
}

/// Preview seed configuration for deterministic mock data
enum PreviewSeed: UInt64 {
    /// Default stable seed for consistent previews
    case stable = 12345
    /// Alternative seed for variety in previews
    case alternative = 67890
    
    var value: UInt64 {
        rawValue
    }
}

/// Helper for creating preview variants with different states and seeds
struct PreviewVariants {
    /// Creates preview variants for a view with different states
    /// - Parameters:
    ///   - name: Base name for the preview
    ///   - content: The view content builder
    ///   - states: Array of states to preview (defaults to all states)
    /// - Returns: Group of preview variants
    @ViewBuilder
    static func states<Content: View>(
        _ name: String,
        @ViewBuilder content: @escaping (PreviewState) -> Content
    ) -> some View {
        Group {
            ForEach(PreviewState.allCases, id: \.self) { state in
                content(state)
                    .previewDisplayName("\(name) - \(state.displayName)")
            }
        }
    }
    
    /// Creates preview variants with different seeds
    /// - Parameters:
    ///   - name: Base name for the preview
    ///   - content: The view content builder
    ///   - seeds: Array of seeds to preview (defaults to all seeds)
    /// - Returns: Group of preview variants
    @ViewBuilder
    static func seeds<Content: View>(
        _ name: String,
        @ViewBuilder content: @escaping (PreviewSeed) -> Content
    ) -> some View {
        Group {
            ForEach([PreviewSeed.stable, PreviewSeed.alternative], id: \.rawValue) { seed in
                content(seed)
                    .previewDisplayName("\(name) - Seed \(seed.rawValue)")
            }
        }
    }
}


