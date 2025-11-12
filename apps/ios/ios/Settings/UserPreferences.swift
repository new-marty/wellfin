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
    
    // MARK: - Default Values
    
    private static let defaultCurrencyFormat = "JPY"
    private static let defaultDateFormat = "MM/dd/yyyy"
    private static let defaultShowNotifications = true
    private static let defaultDemoDataset = false
    private static let defaultReduceMotion = false
    
    // MARK: - Load Preferences
    
    private func loadPreferences() {
        currencyFormat = userDefaults.string(forKey: Keys.currencyFormat) ?? Self.defaultCurrencyFormat
        dateFormat = userDefaults.string(forKey: Keys.dateFormat) ?? Self.defaultDateFormat
        showNotifications = userDefaults.object(forKey: Keys.showNotifications) as? Bool ?? Self.defaultShowNotifications
        demoDataset = userDefaults.object(forKey: Keys.demoDataset) as? Bool ?? Self.defaultDemoDataset
        reduceMotion = userDefaults.object(forKey: Keys.reduceMotion) as? Bool ?? Self.defaultReduceMotion
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
        
        // Clear all preference keys
        let keys = [
            Keys.currencyFormat,
            Keys.dateFormat,
            Keys.showNotifications,
            Keys.demoDataset,
            Keys.reduceMotion
        ]
        
        for key in keys {
            userDefaults.removeObject(forKey: key)
        }
        
        userDefaults.synchronize()
    }
}

