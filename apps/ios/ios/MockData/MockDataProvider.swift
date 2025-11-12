//
//  MockDataProvider.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import Foundation

/// Protocol for providing deterministic mock data with stable seeds
protocol MockDataProvider {
    /// The seed used for generating deterministic data
    var seed: UInt64 { get }
    
    /// Creates a new seeded random generator for this provider
    func makeGenerator() -> SeededRandomGenerator
}

extension MockDataProvider {
    /// Creates a new seeded random generator for this provider
    func makeGenerator() -> SeededRandomGenerator {
        SeededRandomGenerator(seed: seed)
    }
}

/// Default mock data provider with a stable seed
struct DefaultMockDataProvider: MockDataProvider {
    let seed: UInt64 = 12345
    
    static let shared = DefaultMockDataProvider()
}

/// Preview mock data provider with a different seed for variety
struct PreviewMockDataProvider: MockDataProvider {
    let seed: UInt64 = 67890
    
    static let shared = PreviewMockDataProvider()
}

/// Dataset A mock data provider
struct DatasetAProvider: MockDataProvider {
    let seed: UInt64 = 11111
    
    static let shared = DatasetAProvider()
}

/// Dataset B mock data provider
struct DatasetBProvider: MockDataProvider {
    let seed: UInt64 = 22222
    
    static let shared = DatasetBProvider()
}



