//
//  MockData.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Convenience file for accessing mock data generators

import Foundation

/// Convenience accessors for mock data generators
enum MockData {
    /// Default transaction generator
    static var transactions: TransactionGenerator {
        TransactionGenerator(provider: DefaultMockDataProvider.shared)
    }
    
    /// Default account generator
    static var accounts: AccountGenerator {
        AccountGenerator(provider: DefaultMockDataProvider.shared)
    }
    
    /// Default classification generator
    static var classifications: ClassificationGenerator {
        ClassificationGenerator(provider: DefaultMockDataProvider.shared)
    }
    
    /// Default suggestion generator
    static var suggestions: SuggestionGenerator {
        SuggestionGenerator(provider: DefaultMockDataProvider.shared)
    }
    
    /// Preview transaction generator (different seed)
    static var previewTransactions: TransactionGenerator {
        TransactionGenerator(provider: PreviewMockDataProvider.shared)
    }
    
    /// Preview account generator (different seed)
    static var previewAccounts: AccountGenerator {
        AccountGenerator(provider: PreviewMockDataProvider.shared)
    }
    
    /// Preview classification generator (different seed)
    static var previewClassifications: ClassificationGenerator {
        ClassificationGenerator(provider: PreviewMockDataProvider.shared)
    }
    
    /// Preview suggestion generator (different seed)
    static var previewSuggestions: SuggestionGenerator {
        SuggestionGenerator(provider: PreviewMockDataProvider.shared)
    }
}

