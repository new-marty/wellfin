//
//  ClassificationGenerator.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import Foundation

/// Generates deterministic mock classifications
struct ClassificationGenerator {
    private let provider: MockDataProvider
    
    init(provider: MockDataProvider = DefaultMockDataProvider.shared) {
        self.provider = provider
    }
    
    /// Generates a classification for a transaction
    func generate(transactionId: String) -> Classification {
        var gen = provider.makeGenerator()
        
        let intents: [Classification.KakeiboIntent] = [
            .need, .want, .culture, .unexpected
        ]
        
        let categories = [
            "Groceries", "Dining", "Transport", "Shopping", "Entertainment",
            "Bills", "Rent", "Healthcare", "Education", "Travel"
        ]
        
        let tags = [
            "Home", "Travel", "Work", "Tax", "Refund", "Subscription",
            "Business", "Amazon", "Recurring", "One-time"
        ]
        
        let sources: [Classification.ClassificationSource] = [
            .manual, .userRule, .systemHint
        ]
        
        let intent = gen.randomElement(from: intents) ?? .need
        let category = gen.randomElement(from: categories)
        
        // Generate 0-3 tags
        let tagCount = gen.nextInt(upperBound: 4)
        let selectedTags = gen.shuffled(tags).prefix(tagCount)
        
        let source = gen.randomElement(from: sources) ?? .systemHint
        let confidence = gen.nextDouble(lowerBound: 0.5, upperBound: 1.0)
        
        // Generate date within last 30 days
        let daysAgo = gen.nextInt(upperBound: 30)
        let createdAt = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
        
        return Classification(
            id: UUID().uuidString,
            transactionId: transactionId,
            intent: intent,
            category: category,
            tags: Array(selectedTags),
            source: source,
            confidence: confidence,
            createdAt: createdAt
        )
    }
    
    /// Generates classifications for multiple transactions
    func generate(transactionIds: [String]) -> [Classification] {
        return transactionIds.map { generate(transactionId: $0) }
    }
}



