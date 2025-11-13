//
//  Account.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import Foundation

/// Represents a financial account
struct Account: Identifiable, Codable, Equatable {
    let id: String
    let type: AccountType
    let name: String
    let currency: String
    let status: AccountStatus
    let autopayMode: AutopayMode?
    
    enum AccountType: String, Codable {
        case checking
        case savings
        case credit
        case investment
        case loan
        case other
    }
    
    enum AccountStatus: String, Codable {
        case active
        case inactive
        case closed
    }
    
    enum AutopayMode: String, Codable {
        case enabled
        case disabled
    }
}


