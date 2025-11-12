//
//  TransactionGenerator.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import Foundation

/// Generates deterministic mock transactions
struct TransactionGenerator {
    private let provider: MockDataProvider
    
    init(provider: MockDataProvider = DefaultMockDataProvider.shared) {
        self.provider = provider
    }
    
    /// Generates a single transaction
    func generate(accountId: String? = nil) -> Transaction {
        var gen = provider.makeGenerator()
        
        let merchants = [
            "Starbucks", "Amazon", "7-Eleven", "McDonald's", "FamilyMart",
            "Lawson", "UNIQLO", "Apple Store", "Google Play", "Netflix",
            "Spotify", "JR East", "Tokyo Metro", "Uber", "DoorDash"
        ]
        
        let channels: [Transaction.TransactionChannel] = [
            .card, .cash, .bankTransfer, .digitalWallet, .other
        ]
        
        let merchant = gen.randomElement(from: merchants)
        let channel = gen.randomElement(from: channels) ?? .card
        
        // Generate amount between -50000 and 50000 (negative for income)
        let amount = Decimal(gen.nextDouble(lowerBound: -50000, upperBound: 50000))
        
        // Generate date within last 90 days
        let daysAgo = gen.nextInt(upperBound: 90)
        let postedAt = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
        
        return Transaction(
            id: UUID().uuidString,
            accountId: accountId ?? "account-\(gen.nextInt(upperBound: 5))",
            amount: amount,
            currency: "JPY",
            postedAt: postedAt,
            merchant: merchant,
            channel: channel,
            isRecurring: gen.nextBool(),
            isTransfer: gen.nextBool(),
            isBNPL: gen.nextBool()
        )
    }
    
    /// Generates multiple transactions
    func generate(count: Int, accountId: String? = nil) -> [Transaction] {
        var gen = provider.makeGenerator()
        
        let merchants = [
            "Starbucks", "Amazon", "7-Eleven", "McDonald's", "FamilyMart",
            "Lawson", "UNIQLO", "Apple Store", "Google Play", "Netflix",
            "Spotify", "JR East", "Tokyo Metro", "Uber", "DoorDash"
        ]
        
        let channels: [Transaction.TransactionChannel] = [
            .card, .cash, .bankTransfer, .digitalWallet, .other
        ]
        
        return (0..<count).map { _ in
            let merchant = gen.randomElement(from: merchants)
            let channel = gen.randomElement(from: channels) ?? .card
            
            // Generate amount between -50000 and 50000 (negative for income)
            let amount = Decimal(gen.nextDouble(lowerBound: -50000, upperBound: 50000))
            
            // Generate date within last 90 days
            let daysAgo = gen.nextInt(upperBound: 90)
            let postedAt = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
            
            return Transaction(
                id: UUID().uuidString,
                accountId: accountId ?? "account-\(gen.nextInt(upperBound: 5))",
                amount: amount,
                currency: "JPY",
                postedAt: postedAt,
                merchant: merchant,
                channel: channel,
                isRecurring: gen.nextBool(),
                isTransfer: gen.nextBool(),
                isBNPL: gen.nextBool()
            )
        }
    }
    
    /// Generates transactions for a specific date range
    func generate(
        count: Int,
        from startDate: Date,
        to endDate: Date,
        accountId: String? = nil
    ) -> [Transaction] {
        var gen = provider.makeGenerator()
        let timeRange = endDate.timeIntervalSince(startDate)
        
        let merchants = [
            "Starbucks", "Amazon", "7-Eleven", "McDonald's", "FamilyMart",
            "Lawson", "UNIQLO", "Apple Store", "Google Play", "Netflix",
            "Spotify", "JR East", "Tokyo Metro", "Uber", "DoorDash"
        ]
        
        let channels: [Transaction.TransactionChannel] = [
            .card, .cash, .bankTransfer, .digitalWallet, .other
        ]
        
        return (0..<count).map { _ in
            let randomInterval = gen.nextDouble(lowerBound: 0, upperBound: timeRange)
            let postedAt = startDate.addingTimeInterval(randomInterval)
            
            let merchant = gen.randomElement(from: merchants)
            let channel = gen.randomElement(from: channels) ?? .card
            let amount = Decimal(gen.nextDouble(lowerBound: -50000, upperBound: 50000))
            
            return Transaction(
                id: UUID().uuidString,
                accountId: accountId ?? "account-\(gen.nextInt(upperBound: 5))",
                amount: amount,
                currency: "JPY",
                postedAt: postedAt,
                merchant: merchant,
                channel: channel,
                isRecurring: gen.nextBool(),
                isTransfer: gen.nextBool(),
                isBNPL: gen.nextBool()
            )
        }
    }
}

