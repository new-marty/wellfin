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
    
    /// Formats a decimal amount as currency string
    /// Note: Use .monospacedDigit() font modifier for tabular numerals alignment
    /// - Parameter amount: The amount to format
    /// - Returns: Formatted currency string
    func format(_ amount: Decimal) -> String {
        guard let formatted = formatter.string(from: amount as NSDecimalNumber) else {
            return String(describing: amount)
        }
        
        // Return formatted string - tabular numerals are handled via .monospacedDigit() font modifier
        return formatted
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

