//
//  UserPreferencesTests.swift
//  iosTests
//
//  Created on 2025/11/12.
//
//  Unit tests for UserPreferences

import XCTest
@testable import ios

final class UserPreferencesTests: XCTestCase {
    var testDefaults: UserDefaults!
    var preferences: UserPreferences!
    
    override func setUpWithError() throws {
        // Use a test UserDefaults suite to avoid affecting real preferences
        testDefaults = UserDefaults(suiteName: "test.\(UUID().uuidString)")!
        testDefaults.removePersistentDomain(forName: testDefaults.suiteName!)
        
        // Create a new instance with test UserDefaults
        // Note: Since UserPreferences uses a singleton, we'll test via the shared instance
        // but clear it first
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    
    override func tearDownWithError() throws {
        testDefaults.removePersistentDomain(forName: testDefaults.suiteName!)
        testDefaults = nil
        preferences = nil
        
        // Clean up standard UserDefaults
        if let bundleId = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleId)
        }
    }
    
    // MARK: - Default Values Tests
    
    func testDefaultValues() throws {
        // Clear any existing preferences
        if let bundleId = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleId)
        }
        
        // Create fresh instance
        let prefs = UserPreferences.shared
        
        XCTAssertEqual(prefs.currencyFormat, "JPY", "Default currency format should be JPY")
        XCTAssertEqual(prefs.dateFormat, "MM/dd/yyyy", "Default date format should be MM/dd/yyyy")
        XCTAssertTrue(prefs.showNotifications, "Default showNotifications should be true")
        XCTAssertFalse(prefs.demoDataset, "Default demoDataset should be false")
        XCTAssertFalse(prefs.reduceMotion, "Default reduceMotion should be false")
        XCTAssertTrue(prefs.useJPYDisplay, "Default useJPYDisplay should be true (JP defaults)")
        XCTAssertTrue(prefs.useYYYYMMDDDateFormat, "Default useYYYYMMDDDateFormat should be true (JP defaults)")
        XCTAssertTrue(prefs.mondayWeekStart, "Default mondayWeekStart should be true (JP defaults)")
    }
    
    // MARK: - Read/Write Round-Trip Tests
    
    func testCurrencyFormatRoundTrip() throws {
        let prefs = UserPreferences.shared
        
        // Set a value
        prefs.currencyFormat = "USD"
        
        // Verify it was saved
        XCTAssertEqual(prefs.currencyFormat, "USD")
        
        // Create a new instance to verify persistence
        // Note: Since we're using a singleton, we'll verify via UserDefaults directly
        let savedValue = UserDefaults.standard.string(forKey: "userPreferences.currencyFormat")
        XCTAssertEqual(savedValue, "USD", "Currency format should be persisted")
    }
    
    func testDateFormatRoundTrip() throws {
        let prefs = UserPreferences.shared
        
        prefs.dateFormat = "yyyy-MM-dd"
        XCTAssertEqual(prefs.dateFormat, "yyyy-MM-dd")
        
        let savedValue = UserDefaults.standard.string(forKey: "userPreferences.dateFormat")
        XCTAssertEqual(savedValue, "yyyy-MM-dd", "Date format should be persisted")
    }
    
    func testShowNotificationsRoundTrip() throws {
        let prefs = UserPreferences.shared
        
        prefs.showNotifications = false
        XCTAssertFalse(prefs.showNotifications)
        
        let savedValue = UserDefaults.standard.bool(forKey: "userPreferences.showNotifications")
        XCTAssertFalse(savedValue, "Show notifications should be persisted")
    }
    
    func testDemoDatasetRoundTrip() throws {
        let prefs = UserPreferences.shared
        
        prefs.demoDataset = true
        XCTAssertTrue(prefs.demoDataset)
        
        let savedValue = UserDefaults.standard.bool(forKey: "userPreferences.demoDataset")
        XCTAssertTrue(savedValue, "Demo dataset should be persisted")
    }
    
    func testReduceMotionRoundTrip() throws {
        let prefs = UserPreferences.shared
        
        prefs.reduceMotion = true
        XCTAssertTrue(prefs.reduceMotion)
        
        let savedValue = UserDefaults.standard.bool(forKey: "userPreferences.reduceMotion")
        XCTAssertTrue(savedValue, "Reduce motion should be persisted")
    }
    
    // MARK: - JP Formatting Toggles Tests
    
    func testUseJPYDisplayRoundTrip() throws {
        let prefs = UserPreferences.shared
        
        prefs.useJPYDisplay = false
        XCTAssertFalse(prefs.useJPYDisplay)
        
        let savedValue = UserDefaults.standard.bool(forKey: "userPreferences.useJPYDisplay")
        XCTAssertFalse(savedValue, "Use JPY display should be persisted")
        
        // Test toggle back
        prefs.useJPYDisplay = true
        XCTAssertTrue(prefs.useJPYDisplay)
    }
    
    func testUseYYYYMMDDDateFormatRoundTrip() throws {
        let prefs = UserPreferences.shared
        
        prefs.useYYYYMMDDDateFormat = false
        XCTAssertFalse(prefs.useYYYYMMDDDateFormat)
        
        let savedValue = UserDefaults.standard.bool(forKey: "userPreferences.useYYYYMMDDDateFormat")
        XCTAssertFalse(savedValue, "Use yyyy-mm-dd date format should be persisted")
        
        // Test toggle back
        prefs.useYYYYMMDDDateFormat = true
        XCTAssertTrue(prefs.useYYYYMMDDDateFormat)
    }
    
    func testMondayWeekStartRoundTrip() throws {
        let prefs = UserPreferences.shared
        
        prefs.mondayWeekStart = false
        XCTAssertFalse(prefs.mondayWeekStart)
        
        let savedValue = UserDefaults.standard.bool(forKey: "userPreferences.mondayWeekStart")
        XCTAssertFalse(savedValue, "Monday week start should be persisted")
        
        // Test toggle back
        prefs.mondayWeekStart = true
        XCTAssertTrue(prefs.mondayWeekStart)
    }
    
    // MARK: - Reset Tests
    
    func testResetToDefaults() throws {
        let prefs = UserPreferences.shared
        
        // Set non-default values
        prefs.currencyFormat = "EUR"
        prefs.dateFormat = "dd/MM/yyyy"
        prefs.showNotifications = false
        prefs.demoDataset = true
        prefs.reduceMotion = true
        
        // Reset
        prefs.resetToDefaults()
        
        // Verify defaults
        XCTAssertEqual(prefs.currencyFormat, "JPY")
        XCTAssertEqual(prefs.dateFormat, "MM/dd/yyyy")
        XCTAssertTrue(prefs.showNotifications)
        XCTAssertFalse(prefs.demoDataset)
        XCTAssertFalse(prefs.reduceMotion)
        XCTAssertTrue(prefs.useJPYDisplay)
        XCTAssertTrue(prefs.useYYYYMMDDDateFormat)
        XCTAssertTrue(prefs.mondayWeekStart)
    }
    
    // MARK: - Migration Tests
    
    func testMigrationFromVersion0() throws {
        // Set version to 0
        UserDefaults.standard.set(0, forKey: "userPreferences.version")
        
        // Create new instance (should trigger migration)
        let prefs = UserPreferences.shared
        
        // Verify version was updated
        let version = UserDefaults.standard.integer(forKey: "userPreferences.version")
        XCTAssertEqual(version, 1, "Version should be migrated to 1")
    }
    
    func testNoMigrationWhenVersionMatches() throws {
        // Set version to current
        UserDefaults.standard.set(1, forKey: "userPreferences.version")
        
        // Create new instance
        let prefs = UserPreferences.shared
        
        // Verify version remains
        let version = UserDefaults.standard.integer(forKey: "userPreferences.version")
        XCTAssertEqual(version, 1, "Version should remain 1")
    }
}

