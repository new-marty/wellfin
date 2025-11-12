//
//  CurrencyFormatter.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Currency formatting helpers with tabular numerals for stable alignment

import Foundation

/// Currency formatting helper with tabular numerals for stable alignment in lists and charts
struct CurrencyFormatter {
    private let formatter: NumberFormatter
    
    init(locale: Locale = .current, currencyCode: String = "JPY") {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = locale
        
        // Use tabular numerals for fixed-width alignment
        // Tabular numerals have consistent width across all digits (0-9)
        formatter.usesGroupingSeparator = true
        
        // Configure for Japanese yen if needed
        if currencyCode == "JPY" {
            formatter.currencySymbol = "¥"
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits = 0
        }
        
        self.formatter = formatter
    }
    
    /// Formats a decimal amount as currency string with tabular numerals
    /// - Parameter amount: The amount to format
    /// - Returns: Formatted currency string with tabular numerals
    func format(_ amount: Decimal) -> String {
        guard let formatted = formatter.string(from: amount as NSDecimalNumber) else {
            return String(describing: amount)
        }
        
        // Convert to tabular numerals (U+0030-U+0039 become U+EFF0-U+EFF9)
        // This ensures consistent width for alignment
        return convertToTabularNumerals(formatted)
    }
    
    /// Converts regular numerals to tabular numerals for fixed-width display
    /// Tabular numerals (U+EFF0-U+EFF9) have consistent width unlike proportional numerals
    private func convertToTabularNumerals(_ string: String) -> String {
        let tabularMap: [Character: Character] = [
            "0": "\u{EFF0}", "1": "\u{EFF1}", "2": "\u{EFF2}", "3": "\u{EFF3}",
            "4": "\u{EFF4}", "5": "\u{EFF5}", "6": "\u{EFF6}", "7": "\u{EFF7}",
            "8": "\u{EFF8}", "9": "\u{EFF9}"
        ]
        
        return String(string.map { tabularMap[$0] ?? $0 })
    }
    
    /// Formats currency with locale-aware spacing and symbols
    /// - Parameters:
    ///   - amount: The amount to format
    ///   - locale: The locale to use for formatting
    /// - Returns: Formatted currency string
    static func format(_ amount: Decimal, currencyCode: String = "JPY", locale: Locale = .current) -> String {
        let formatter = CurrencyFormatter(locale: locale, currencyCode: currencyCode)
        return formatter.format(amount)
    }
}

