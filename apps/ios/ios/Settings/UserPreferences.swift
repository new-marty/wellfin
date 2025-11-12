//
//  UserPreferences.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  User preferences manager using UserDefaults with versioning and migration support

import Foundation
import SwiftUI

/// User preferences manager with UserDefaults persistence
/// Supports versioning and migration for future key changes
@Observable
final class UserPreferences {
    static let shared = UserPreferences()
    
    // MARK: - Keys
    
    private enum Keys {
        static let version = "userPreferences.version"
        static let preferencesPrefix = "userPreferences."
        
        // Preference keys
        static let currencyFormat = "\(preferencesPrefix)currencyFormat"
        static let dateFormat = "\(preferencesPrefix)dateFormat"
        static let showNotifications = "\(preferencesPrefix)showNotifications"
        static let demoDataset = "\(preferencesPrefix)demoDataset"
        static let reduceMotion = "\(preferencesPrefix)reduceMotion"
        
        // JP formatting toggles
        static let useJPYDisplay = "\(preferencesPrefix)useJPYDisplay"
        static let useYYYYMMDDDateFormat = "\(preferencesPrefix)useYYYYMMDDDateFormat"
        static let mondayWeekStart = "\(preferencesPrefix)mondayWeekStart"
    }
    
    // MARK: - Current Version
    
    private static let currentVersion = 1
    
    // MARK: - UserDefaults
    
    private let userDefaults: UserDefaults
    
    // MARK: - Initialization
    
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        // Initialize with defaults first
        self.currencyFormat = Self.defaultCurrencyFormat
        self.dateFormat = Self.defaultDateFormat
        self.showNotifications = Self.defaultShowNotifications
        self.demoDataset = Self.defaultDemoDataset
        self.reduceMotion = Self.defaultReduceMotion
        self.useJPYDisplay = Self.defaultUseJPYDisplay
        self.useYYYYMMDDDateFormat = Self.defaultUseYYYYMMDDDateFormat
        self.mondayWeekStart = Self.defaultMondayWeekStart
        
        // Then migrate and load
        migrateIfNeeded()
        loadPreferences()
    }
    
    // MARK: - Preferences Properties
    
    /// Currency format preference (e.g., "JPY", "USD")
    var currencyFormat: String {
        didSet {
            save(key: Keys.currencyFormat, value: currencyFormat)
        }
    }
    
    /// Date format preference (e.g., "MM/dd/yyyy", "yyyy-MM-dd")
    var dateFormat: String {
        didSet {
            save(key: Keys.dateFormat, value: dateFormat)
        }
    }
    
    /// Show notifications toggle
    var showNotifications: Bool {
        didSet {
            save(key: Keys.showNotifications, value: showNotifications)
        }
    }
    
    /// Use demo dataset toggle
    var demoDataset: Bool {
        didSet {
            save(key: Keys.demoDataset, value: demoDataset)
        }
    }
    
    /// Reduce motion preference (respects system accessibility setting)
    var reduceMotion: Bool {
        didSet {
            save(key: Keys.reduceMotion, value: reduceMotion)
        }
    }
    
    /// Use JPY currency display format (¥ symbol, Japanese formatting)
    var useJPYDisplay: Bool {
        didSet {
            save(key: Keys.useJPYDisplay, value: useJPYDisplay)
        }
    }
    
    /// Use yyyy-mm-dd date format (ISO 8601 style)
    var useYYYYMMDDDateFormat: Bool {
        didSet {
            save(key: Keys.useYYYYMMDDDateFormat, value: useYYYYMMDDDateFormat)
        }
    }
    
    /// Use Monday as week start (instead of Sunday)
    var mondayWeekStart: Bool {
        didSet {
            save(key: Keys.mondayWeekStart, value: mondayWeekStart)
        }
    }
    
    // MARK: - Default Values
    
    private static let defaultCurrencyFormat = "JPY"
    private static let defaultDateFormat = "MM/dd/yyyy"
    private static let defaultShowNotifications = true
    private static let defaultDemoDataset = false
    private static let defaultReduceMotion = false
    private static let defaultUseJPYDisplay = true // JP defaults
    private static let defaultUseYYYYMMDDDateFormat = true // JP defaults
    private static let defaultMondayWeekStart = true // JP defaults
    
    // MARK: - Load Preferences
    
    private func loadPreferences() {
        currencyFormat = userDefaults.string(forKey: Keys.currencyFormat) ?? Self.defaultCurrencyFormat
        dateFormat = userDefaults.string(forKey: Keys.dateFormat) ?? Self.defaultDateFormat
        showNotifications = userDefaults.object(forKey: Keys.showNotifications) as? Bool ?? Self.defaultShowNotifications
        demoDataset = userDefaults.object(forKey: Keys.demoDataset) as? Bool ?? Self.defaultDemoDataset
        reduceMotion = userDefaults.object(forKey: Keys.reduceMotion) as? Bool ?? Self.defaultReduceMotion
        useJPYDisplay = userDefaults.object(forKey: Keys.useJPYDisplay) as? Bool ?? Self.defaultUseJPYDisplay
        useYYYYMMDDDateFormat = userDefaults.object(forKey: Keys.useYYYYMMDDDateFormat) as? Bool ?? Self.defaultUseYYYYMMDDDateFormat
        mondayWeekStart = userDefaults.object(forKey: Keys.mondayWeekStart) as? Bool ?? Self.defaultMondayWeekStart
    }
    
    // MARK: - Save Preferences
    
    private func save(key: String, value: Any) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    // MARK: - Migration
    
    /// Migrates preferences if version has changed
    private func migrateIfNeeded() {
        let storedVersion = userDefaults.integer(forKey: Keys.version)
        
        if storedVersion < Self.currentVersion {
            performMigration(from: storedVersion, to: Self.currentVersion)
            userDefaults.set(Self.currentVersion, forKey: Keys.version)
            userDefaults.synchronize()
        }
    }
    
    /// Performs migration between versions
    /// - Parameters:
    ///   - fromVersion: Source version
    ///   - toVersion: Target version
    private func performMigration(from fromVersion: Int, to toVersion: Int) {
        // Version 0 -> 1: Initial migration (no-ops acceptable for MVP)
        // Future migrations can be added here as needed
        if fromVersion == 0 && toVersion >= 1 {
            // Initial version, no migration needed
            // This is where we'd migrate old keys if they existed
        }
        
        // Add future migrations here:
        // if fromVersion < 2 && toVersion >= 2 {
        //     // Migrate from version 1 to 2
        // }
    }
    
    // MARK: - Reset
    
    /// Resets all preferences to default values
    func resetToDefaults() {
        currencyFormat = Self.defaultCurrencyFormat
        dateFormat = Self.defaultDateFormat
        showNotifications = Self.defaultShowNotifications
        demoDataset = Self.defaultDemoDataset
        reduceMotion = Self.defaultReduceMotion
        useJPYDisplay = Self.defaultUseJPYDisplay
        useYYYYMMDDDateFormat = Self.defaultUseYYYYMMDDDateFormat
        mondayWeekStart = Self.defaultMondayWeekStart
        
        // Clear all preference keys
        let keys = [
            Keys.currencyFormat,
            Keys.dateFormat,
            Keys.showNotifications,
            Keys.demoDataset,
            Keys.reduceMotion,
            Keys.useJPYDisplay,
            Keys.useYYYYMMDDDateFormat,
            Keys.mondayWeekStart
        ]
        
        for key in keys {
            userDefaults.removeObject(forKey: key)
        }
        
        userDefaults.synchronize()
    }
}

