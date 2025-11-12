//
//  AccountGenerator.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import Foundation

/// Generates deterministic mock accounts
struct AccountGenerator {
    private let provider: MockDataProvider
    
    init(provider: MockDataProvider = DefaultMockDataProvider.shared) {
        self.provider = provider
    }
    
    /// Generates a single account
    func generate() -> Account {
        var gen = provider.makeGenerator()
        
        let accountTypes: [Account.AccountType] = [
            .checking, .savings, .credit, .investment, .loan
        ]
        
        let accountNames = [
            "Main Checking", "Savings Account", "Credit Card", "Investment Portfolio",
            "Emergency Fund", "Travel Fund", "House Loan", "Car Loan"
        ]
        
        let currencies = ["JPY", "USD", "EUR"]
        
        let type = gen.randomElement(from: accountTypes) ?? .checking
        let name = gen.randomElement(from: accountNames) ?? "Account"
        let currency = gen.randomElement(from: currencies) ?? "JPY"
        
        let status: Account.AccountStatus = gen.nextBool() ? .active : .inactive
        let autopayMode: Account.AutopayMode? = type == .credit ? 
            (gen.nextBool() ? .enabled : .disabled) : nil
        
        return Account(
            id: UUID().uuidString,
            type: type,
            name: name,
            currency: currency,
            status: status,
            autopayMode: autopayMode
        )
    }
    
    /// Generates multiple accounts
    func generate(count: Int) -> [Account] {
        return (0..<count).map { _ in
            generate()
        }
    }
}

