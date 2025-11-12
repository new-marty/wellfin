//
//  Transaction.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import Foundation

/// Represents a financial transaction
struct Transaction: Identifiable, Codable, Equatable {
    let id: String
    let accountId: String
    let amount: Decimal
    let currency: String
    let postedAt: Date
    let merchant: String?
    let channel: TransactionChannel
    let isRecurring: Bool
    let isTransfer: Bool
    let isBNPL: Bool
    
    enum TransactionChannel: String, Codable {
        case card
        case cash
        case bankTransfer
        case digitalWallet
        case other
    }
}



