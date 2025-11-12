//
//  MockDataExample.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Example usage of MockDataProvider and generators
//  This file demonstrates how to use the mock data system

import Foundation

#if DEBUG
/// Example usage of mock data generators
enum MockDataExample {
    /// Example: Generate sample transactions
    static func sampleTransactions(count: Int = 10) -> [Transaction] {
        return MockData.transactions.generate(count: count)
    }
    
    /// Example: Generate sample accounts
    static func sampleAccounts(count: Int = 5) -> [Account] {
        return MockData.accounts.generate(count: count)
    }
    
    /// Example: Generate classifications for transactions
    static func sampleClassifications(for transactions: [Transaction]) -> [Classification] {
        let transactionIds = transactions.map { $0.id }
        return MockData.classifications.generate(transactionIds: transactionIds)
    }
    
    /// Example: Generate pending suggestions
    static func sampleSuggestions(count: Int = 5) -> [Suggestion] {
        return MockData.suggestions.generatePending(count: count)
    }
    
    /// Example: Generate a complete dataset (accounts + transactions + classifications)
    static func sampleDataset(
        accountCount: Int = 3,
        transactionCountPerAccount: Int = 10
    ) -> (accounts: [Account], transactions: [Transaction], classifications: [Classification]) {
        let accounts = MockData.accounts.generate(count: accountCount)
        
        var allTransactions: [Transaction] = []
        for account in accounts {
            let transactions = MockData.transactions.generate(
                count: transactionCountPerAccount,
                accountId: account.id
            )
            allTransactions.append(contentsOf: transactions)
        }
        
        let classifications = MockData.classifications.generate(
            transactionIds: allTransactions.map { $0.id }
        )
        
        return (accounts, allTransactions, classifications)
    }
    
    /// Example: Demonstrate deterministic behavior with same seed
    static func demonstrateDeterminism() {
        let provider1 = DefaultMockDataProvider.shared
        let provider2 = DefaultMockDataProvider.shared
        
        let gen1 = provider1.makeGenerator()
        let gen2 = provider2.makeGenerator()
        
        // Both generators with the same seed should produce the same sequence
        var g1 = gen1
        var g2 = gen2
        
        let value1 = g1.nextInt(upperBound: 100)
        let value2 = g2.nextInt(upperBound: 100)
        
        assert(value1 == value2, "Same seed should produce same values")
        
        // Generate transactions with same provider should be deterministic
        let transactions1 = TransactionGenerator(provider: provider1).generate(count: 5)
        let transactions2 = TransactionGenerator(provider: provider2).generate(count: 5)
        
        // Note: UUIDs will differ, but amounts, dates, merchants should be the same
        // This is a simplified check - in practice, you'd compare specific fields
        assert(transactions1.count == transactions2.count, "Should generate same count")
    }
}
#endif



