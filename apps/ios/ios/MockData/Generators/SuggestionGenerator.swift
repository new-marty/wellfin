//
//  SuggestionGenerator.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import Foundation

/// Generates deterministic mock suggestions
struct SuggestionGenerator {
    private let provider: MockDataProvider
    
    init(provider: MockDataProvider = DefaultMockDataProvider.shared) {
        self.provider = provider
    }
    
    /// Generates a single suggestion
    func generate() -> Suggestion {
        var gen = provider.makeGenerator()
        
        let types: [Suggestion.SuggestionType] = [
            .moveToSavings, .adjustBudget, .reviewSubscription,
            .categorizeTransaction, .createRule, .other
        ]
        
        let states: [Suggestion.SuggestionState] = [
            .pending, .accepted, .declined, .snoozed
        ]
        
        let type = gen.randomElement(from: types) ?? .other
        let state = gen.randomElement(from: states) ?? .pending
        
        // Generate inputs based on type
        var inputs: [String: String] = [:]
        switch type {
        case .moveToSavings:
            inputs["amount"] = "\(gen.nextInt(lowerBound: 1000, upperBound: 50000))"
            inputs["reason"] = "You have extra funds this month"
        case .adjustBudget:
            inputs["category"] = gen.randomElement(from: ["Groceries", "Dining", "Shopping"]) ?? "Groceries"
            inputs["current"] = "\(gen.nextInt(lowerBound: 10000, upperBound: 50000))"
            inputs["suggested"] = "\(gen.nextInt(lowerBound: 15000, upperBound: 60000))"
        case .reviewSubscription:
            inputs["service"] = gen.randomElement(from: ["Netflix", "Spotify", "Amazon Prime"]) ?? "Netflix"
            inputs["amount"] = "\(gen.nextInt(lowerBound: 500, upperBound: 2000))"
        case .categorizeTransaction:
            inputs["transactionId"] = UUID().uuidString
            inputs["suggestedCategory"] = gen.randomElement(from: ["Groceries", "Dining", "Transport"]) ?? "Groceries"
        case .createRule:
            inputs["merchant"] = gen.randomElement(from: ["Amazon", "Starbucks", "7-Eleven"]) ?? "Amazon"
            inputs["action"] = "Auto-tag as Shopping"
        case .other:
            inputs["message"] = "Review your spending patterns"
        }
        
        let expectedImpact = gen.randomElement(from: [
            "Save ¥5,000 this month",
            "Reduce overspending by 15%",
            "Optimize subscription costs",
            "Improve categorization accuracy"
        ]) ?? "Improve your finances"
        
        let confidence = gen.nextDouble(lowerBound: 0.6, upperBound: 1.0)
        
        // Generate date within last 7 days
        let daysAgo = gen.nextInt(upperBound: 7)
        let createdAt = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
        
        // Some suggestions expire
        let expiresAt: Date? = gen.nextBool() ? 
            Calendar.current.date(byAdding: .day, value: 7, to: createdAt) : nil
        
        return Suggestion(
            id: UUID().uuidString,
            type: type,
            inputs: inputs,
            expectedImpact: expectedImpact,
            confidence: confidence,
            createdAt: createdAt,
            expiresAt: expiresAt,
            state: state
        )
    }
    
    /// Generates multiple suggestions
    func generate(count: Int) -> [Suggestion] {
        return (0..<count).map { _ in generate() }
    }
    
    /// Generates only pending suggestions
    func generatePending(count: Int) -> [Suggestion] {
        return (0..<count).map { _ in
            let suggestion = generate()
            // Force state to pending
            return Suggestion(
                id: suggestion.id,
                type: suggestion.type,
                inputs: suggestion.inputs,
                expectedImpact: suggestion.expectedImpact,
                confidence: suggestion.confidence,
                createdAt: suggestion.createdAt,
                expiresAt: suggestion.expiresAt,
                state: .pending
            )
        }
    }
}

