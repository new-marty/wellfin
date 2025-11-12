//
//  MockDataProvider.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import Foundation

/// Dataset variant identifier
enum DatasetVariant: String, CaseIterable {
    case datasetA = "datasetA"
    case datasetB = "datasetB"
}

/// Protocol for providing deterministic mock data with stable seeds
protocol MockDataProvider {
    /// The seed used for generating deterministic data
    var seed: UInt64 { get }
    
    /// The dataset variant being used
    var datasetVariant: DatasetVariant { get }
    
    /// Creates a new seeded random generator for this provider
    func makeGenerator() -> SeededRandomGenerator
    
    // MARK: - Core Domain Methods
    
    /// Generates transactions for the current dataset
    func generateTransactions(count: Int) -> [Transaction]
    
    /// Generates suggestions for the current dataset
    func generateSuggestions(count: Int) -> [Suggestion]
    
    /// Generates accounts for the current dataset
    func generateAccounts(count: Int) -> [Account]
    
    /// Generates classifications for the current dataset
    func generateClassifications(count: Int) -> [Classification]
}

extension MockDataProvider {
    /// Creates a new seeded random generator for this provider
    func makeGenerator() -> SeededRandomGenerator {
        SeededRandomGenerator(seed: seed)
    }
    
    /// Generates transactions for the current dataset
    func generateTransactions(count: Int) -> [Transaction] {
        let generator = TransactionGenerator(provider: self)
        return generator.generate(count: count)
    }
    
    /// Generates suggestions for the current dataset
    func generateSuggestions(count: Int) -> [Suggestion] {
        let generator = SuggestionGenerator(provider: self)
        return generator.generate(count: count)
    }
    
    /// Generates accounts for the current dataset
    func generateAccounts(count: Int) -> [Account] {
        let generator = AccountGenerator(provider: self)
        return generator.generate(count: count)
    }
    
    /// Generates classifications for the current dataset
    /// Note: Classifications require transactions, so this generates transactions first
    func generateClassifications(count: Int) -> [Classification] {
        // First generate transactions to get their IDs
        let transactions = generateTransactions(count: count)
        let transactionIds = transactions.map { $0.id }
        
        // Then generate classifications for those transactions
        let generator = ClassificationGenerator(provider: self)
        return generator.generate(transactionIds: transactionIds)
    }
}

/// Default mock data provider with a stable seed (datasetA)
struct DefaultMockDataProvider: MockDataProvider {
    let seed: UInt64 = 12345
    let datasetVariant: DatasetVariant = .datasetA
    
    static let shared = DefaultMockDataProvider()
}

/// Preview mock data provider with a different seed for variety (datasetB)
struct PreviewMockDataProvider: MockDataProvider {
    let seed: UInt64 = 67890
    let datasetVariant: DatasetVariant = .datasetB
    
    static let shared = PreviewMockDataProvider()
}

/// Custom mock data provider that allows runtime configuration
struct ConfigurableMockDataProvider: MockDataProvider {
    let seed: UInt64
    let datasetVariant: DatasetVariant
    
    init(seed: UInt64, datasetVariant: DatasetVariant = .datasetA) {
        self.seed = seed
        self.datasetVariant = datasetVariant
    }
    
    /// Creates a provider for datasetA with a custom seed
    static func datasetA(seed: UInt64 = 12345) -> ConfigurableMockDataProvider {
        ConfigurableMockDataProvider(seed: seed, datasetVariant: .datasetA)
    }
    
    /// Creates a provider for datasetB with a custom seed
    static func datasetB(seed: UInt64 = 67890) -> ConfigurableMockDataProvider {
        ConfigurableMockDataProvider(seed: seed, datasetVariant: .datasetB)
    }
}

