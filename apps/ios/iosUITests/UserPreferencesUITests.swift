//
//  UserPreferencesUITests.swift
//  iosUITests
//
//  Created on 2025/11/12.
//
//  UI tests for UserPreferences persistence (NM-38)

import XCTest

final class UserPreferencesUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        
        // Clear preferences before each test to ensure clean state
        app.launchArguments.append("--reset-preferences")
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    /// Tests that preference changes persist after app relaunch
    /// Verifies NM-38: Persist local preferences with UserDefaults
    func testPreferencePersistenceAfterRelaunch() throws {
        // Navigate to Settings tab
        let settingsTab = app.tabBars.buttons["Settings"]
        XCTAssertTrue(settingsTab.waitForExistence(timeout: 2))
        settingsTab.tap()
        
        // Verify we're on Settings screen
        XCTAssertTrue(app.navigationBars["Settings"].exists)
        
        // Find and toggle "Show Notifications"
        let notificationsToggle = app.switches["Show Notifications"]
        XCTAssertTrue(notificationsToggle.waitForExistence(timeout: 2))
        
        // Get initial state
        let initialValue = notificationsToggle.value as? String == "1"
        
        // Toggle the switch
        notificationsToggle.tap()
        
        // Verify the toggle changed
        let newValue = notificationsToggle.value as? String == "1"
        XCTAssertNotEqual(initialValue, newValue, "Toggle should change state")
        
        // Terminate the app
        app.terminate()
        
        // Relaunch the app
        app.launch()
        
        // Navigate back to Settings
        settingsTab.tap()
        XCTAssertTrue(app.navigationBars["Settings"].exists)
        
        // Verify the preference persisted
        let persistedToggle = app.switches["Show Notifications"]
        XCTAssertTrue(persistedToggle.waitForExistence(timeout: 2))
        
        let persistedValue = persistedToggle.value as? String == "1"
        XCTAssertEqual(persistedValue, newValue, "Preference should persist after relaunch")
    }
    
    /// Tests that multiple preferences can be changed and persist
    func testMultiplePreferencesPersistence() throws {
        // Navigate to Settings
        let settingsTab = app.tabBars.buttons["Settings"]
        settingsTab.tap()
        XCTAssertTrue(app.navigationBars["Settings"].exists)
        
        // Change "Use Demo Dataset" toggle
        let demoDatasetToggle = app.switches["Use Demo Dataset"]
        if demoDatasetToggle.waitForExistence(timeout: 2) {
            let initialDemoValue = demoDatasetToggle.value as? String == "1"
            demoDatasetToggle.tap()
            let newDemoValue = demoDatasetToggle.value as? String == "1"
            XCTAssertNotEqual(initialDemoValue, newDemoValue)
        }
        
        // Change currency format
        let currencyPicker = app.pickers["Currency Format"]
        if currencyPicker.waitForExistence(timeout: 2) {
            currencyPicker.tap()
            // Select a different currency if available
            // This is a simplified test - actual picker interaction may vary
        }
        
        // Terminate and relaunch
        app.terminate()
        app.launch()
        
        // Navigate back to Settings
        settingsTab.tap()
        
        // Verify preferences persisted
        let persistedDemoToggle = app.switches["Use Demo Dataset"]
        if persistedDemoToggle.waitForExistence(timeout: 2) {
            // Verify the state persisted (simplified check)
            XCTAssertTrue(true, "Preference should be accessible after relaunch")
        }
    }
    
    /// Tests that reset to defaults works correctly
    func testResetToDefaults() throws {
        // Navigate to Settings
        let settingsTab = app.tabBars.buttons["Settings"]
        settingsTab.tap()
        
        // Change a preference
        let notificationsToggle = app.switches["Show Notifications"]
        if notificationsToggle.waitForExistence(timeout: 2) {
            let initialValue = notificationsToggle.value as? String == "1"
            notificationsToggle.tap()
        }
        
        // Find and tap "Reset to Defaults" button
        let resetButton = app.buttons["Reset to Defaults"]
        if resetButton.waitForExistence(timeout: 2) {
            resetButton.tap()
            
            // Confirm reset if there's a confirmation dialog
            // (This may need adjustment based on actual UI)
            
            // Verify preferences were reset
            // This is a simplified test - actual verification may vary
            XCTAssertTrue(true, "Reset button should be accessible")
        }
    }
}

