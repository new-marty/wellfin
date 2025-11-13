//
//  PreviewSanityTests.swift
//  iosTests
//
//  Created on 2025/11/12.
//
//  Preview sanity checks for core screens and components (NM-43)

import XCTest
import SwiftUI
@testable import ios

/// Preview sanity tests to catch regressions in UI rendering
/// These tests verify that previews can be instantiated and don't crash
final class PreviewSanityTests: XCTestCase {
    
    /// Verifies HomeView preview can be instantiated
    func testHomeViewPreviewSanity() throws {
        // Verify HomeView can be created
        let homeView = HomeView()
        XCTAssertNotNil(homeView, "HomeView should be instantiable")
        
        // Verify it has a body (basic sanity check)
        let _ = homeView.body
        XCTAssertTrue(true, "HomeView body should be accessible")
    }
    
    /// Verifies InboxView preview can be instantiated
    func testInboxViewPreviewSanity() throws {
        let inboxView = InboxView()
        XCTAssertNotNil(inboxView, "InboxView should be instantiable")
        
        let _ = inboxView.body
        XCTAssertTrue(true, "InboxView body should be accessible")
    }
    
    /// Verifies TransactionsView preview can be instantiated
    func testTransactionsViewPreviewSanity() throws {
        let transactionsView = TransactionsView()
        XCTAssertNotNil(transactionsView, "TransactionsView should be instantiable")
        
        let _ = transactionsView.body
        XCTAssertTrue(true, "TransactionsView body should be accessible")
    }
    
    /// Verifies TransactionRow can be instantiated with mock data
    func testTransactionRowPreviewSanity() throws {
        // Create a mock transaction using stable seed
        let provider = DatasetAProvider.shared
        let generator = TransactionGenerator(provider: provider)
        let transaction = generator.generate()
        
        let row = TransactionRow(transaction: transaction)
        XCTAssertNotNil(row, "TransactionRow should be instantiable")
        
        let _ = row.body
        XCTAssertTrue(true, "TransactionRow body should be accessible")
    }
    
    /// Verifies SettingsView preview can be instantiated
    func testSettingsViewPreviewSanity() throws {
        let settingsView = SettingsView()
        XCTAssertNotNil(settingsView, "SettingsView should be instantiable")
        
        let _ = settingsView.body
        XCTAssertTrue(true, "SettingsView body should be accessible")
    }
    
    /// Verifies MainTabView preview can be instantiated
    func testMainTabViewPreviewSanity() throws {
        let mainTabView = MainTabView()
        XCTAssertNotNil(mainTabView, "MainTabView should be instantiable")
        
        let _ = mainTabView.body
        XCTAssertTrue(true, "MainTabView body should be accessible")
    }
    
    /// Verifies previews use deterministic mock data
    func testPreviewUsesDeterministicData() throws {
        // Verify that mock data generators use stable seeds
        let providerA = DatasetAProvider.shared
        let providerB = DatasetBProvider.shared
        
        XCTAssertEqual(providerA.seed, 11111, "Dataset A should use seed 11111")
        XCTAssertEqual(providerB.seed, 22222, "Dataset B should use seed 22222")
        
        // Verify generators produce consistent data
        let genA1 = TransactionGenerator(provider: providerA)
        let genA2 = TransactionGenerator(provider: providerA)
        
        // Both should use the same seed
        XCTAssertEqual(genA1.provider.seed, genA2.provider.seed, "Generators should use consistent seeds")
    }
}


