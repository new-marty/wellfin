//
//  Suggestion.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import Foundation

/// Represents a suggestion for the user
struct Suggestion: Identifiable, Codable, Equatable {
    let id: String
    let type: SuggestionType
    let inputs: [String: String]
    let expectedImpact: String
    let confidence: Double
    let createdAt: Date
    let expiresAt: Date?
    let state: SuggestionState
    
    enum SuggestionType: String, Codable {
        case moveToSavings
        case adjustBudget
        case reviewSubscription
        case categorizeTransaction
        case createRule
        case other
    }
    
    enum SuggestionState: String, Codable {
        case pending
        case accepted
        case declined
        case snoozed
        case expired
    }
}

