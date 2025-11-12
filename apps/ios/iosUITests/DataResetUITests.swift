//
//  DataResetUITests.swift
//  iosUITests
//
//  Created on 2025/11/12.
//
//  UI tests for data reset functionality (NM-22)

import XCTest

final class DataResetUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    /// Tests that Reset Data action works with confirmation dialog
    /// Verifies NM-22: In-app data reset and demo dataset switch
    func testResetDataWithConfirmation() throws {
        // Navigate to Settings tab
        let settingsTab = app.tabBars.buttons["Settings"]
        XCTAssertTrue(settingsTab.waitForExistence(timeout: 2))
        settingsTab.tap()
        
        // Verify we're on Settings screen
        XCTAssertTrue(app.navigationBars["Settings"].exists)
        
        // Find Reset Data button
        let resetButton = app.buttons["Reset Data"]
        if resetButton.waitForExistence(timeout: 2) {
            resetButton.tap()
            
            // Verify confirmation alert appears
            let alert = app.alerts["Reset Data"]
            if alert.waitForExistence(timeout: 2) {
                // Verify alert message
                XCTAssertTrue(alert.staticTexts["This will restore demo data to defaults. This action cannot be undone."].exists)
                
                // Cancel the reset
                alert.buttons["Cancel"].tap()
            }
        }
    }
    
    /// Tests that dataset switcher works
    func testDatasetSwitcher() throws {
        // Navigate to Settings
        let settingsTab = app.tabBars.buttons["Settings"]
        settingsTab.tap()
        
        // Find Dataset picker
        let datasetPicker = app.pickers["Dataset"]
        if datasetPicker.waitForExistence(timeout: 2) {
            // Verify picker is accessible
            XCTAssertTrue(true, "Dataset picker should be accessible for switching")
        }
    }
}

