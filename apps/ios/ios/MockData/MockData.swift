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
    /// Current dataset provider based on user preferences
    private static var currentProvider: MockDataProvider {
        let selectedDataset = UserPreferences.shared.selectedDataset
        switch selectedDataset {
        case "B":
            return DatasetBProvider.shared
        case "A":
            return DatasetAProvider.shared
        default:
            return DatasetAProvider.shared
        }
    }
    
    /// Default transaction generator (uses selected dataset)
    static var transactions: TransactionGenerator {
        TransactionGenerator(provider: currentProvider)
    }
    
    /// Default account generator (uses selected dataset)
    static var accounts: AccountGenerator {
        AccountGenerator(provider: currentProvider)
    }
    
    /// Default classification generator (uses selected dataset)
    static var classifications: ClassificationGenerator {
        ClassificationGenerator(provider: currentProvider)
    }
    
    /// Default suggestion generator (uses selected dataset)
    static var suggestions: SuggestionGenerator {
        SuggestionGenerator(provider: currentProvider)
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



