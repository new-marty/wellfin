//
//  DateFormatter.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Date formatting helpers with locale-aware patterns and fixed-width numerals

import Foundation

/// Date formatting helper with locale-aware patterns and fixed-width numerals
struct WellfinDateFormatter {
    private let formatter: Foundation.DateFormatter
    
    init(locale: Locale = .current, dateFormat: String? = nil) {
        let formatter = Foundation.DateFormatter()
        formatter.locale = locale
        
        if let dateFormat = dateFormat {
            formatter.dateFormat = dateFormat
        } else {
            // Use locale-aware date format
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
        }
        
        self.formatter = formatter
    }
    
    /// Formats a date with locale-aware patterns
    /// - Parameter date: The date to format
    /// - Returns: Formatted date string
    func format(_ date: Date) -> String {
        let formatted = formatter.string(from: date)
        return convertToFixedWidthNumerals(formatted)
    }
    
    /// Formats a date using yyyy-MM-dd format (ISO 8601 style)
    /// - Parameter date: The date to format
    /// - Returns: Formatted date string in yyyy-MM-dd format
    func formatISO8601(_ date: Date) -> String {
        let isoFormatter = Foundation.DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd"
        isoFormatter.locale = Locale(identifier: "en_US_POSIX") // Use POSIX for ISO format
        return isoFormatter.string(from: date)
    }
    
    /// Converts numerals to fixed-width tabular numerals where appropriate
    /// This ensures consistent alignment in lists and tables
    private func convertToFixedWidthNumerals(_ string: String) -> String {
        let tabularMap: [Character: Character] = [
            "0": "\u{EFF0}", "1": "\u{EFF1}", "2": "\u{EFF2}", "3": "\u{EFF3}",
            "4": "\u{EFF4}", "5": "\u{EFF5}", "6": "\u{EFF6}", "7": "\u{EFF7}",
            "8": "\u{EFF8}", "9": "\u{EFF9}"
        ]
        
        return String(string.map { tabularMap[$0] ?? $0 })
    }
    
    /// Formats date with locale-aware pattern
    /// - Parameters:
    ///   - date: The date to format
    ///   - locale: The locale to use
    ///   - useISO8601: Whether to use yyyy-MM-dd format
    /// - Returns: Formatted date string
    static func format(_ date: Date, locale: Locale = .current, useISO8601: Bool = false) -> String {
        let formatter = WellfinDateFormatter(locale: locale)
        if useISO8601 {
            return formatter.formatISO8601(date)
        }
        return formatter.format(date)
    }
}

