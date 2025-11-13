//
//  Classification.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import Foundation

/// Represents transaction classification (Kakeibo intent + category + tags)
struct Classification: Identifiable, Codable, Equatable {
    let id: String
    let transactionId: String
    let intent: KakeiboIntent
    let category: String?
    let tags: [String]
    let source: ClassificationSource
    let confidence: Double
    let createdAt: Date
    
    enum KakeiboIntent: String, Codable {
        case need
        case want
        case culture
        case unexpected
    }
    
    enum ClassificationSource: String, Codable {
        case manual
        case userRule
        case systemHint
    }
}


