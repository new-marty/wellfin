//
//  Logger.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Centralized logging system for debug builds

import Foundation
import OSLog

#if DEBUG
/// Log level for categorizing log entries
enum LogLevel: String, CaseIterable {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    
    var color: String {
        switch self {
        case .debug: return "🔵"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "🔴"
        }
    }
}

/// Log entry structure
struct LogEntry: Identifiable {
    let id = UUID()
    let timestamp: Date
    let level: LogLevel
    let message: String
    let category: String?
    
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: timestamp)
    }
    
    var displayMessage: String {
        if let category = category {
            return "[\(category)] \(message)"
        }
        return message
    }
}

/// Centralized logger that captures logs for console panel
@Observable
final class Logger {
    static let shared = Logger()
    
    private var logs: [LogEntry] = []
    private let maxLogs = 200 // Minimum 200 lines as per requirements
    private let queue = DispatchQueue(label: "com.wellfin.logger", attributes: .concurrent)
    
    private init() {}
    
    /// Logs a message with optional category
    func log(_ message: String, level: LogLevel = .info, category: String? = nil) {
        queue.async(flags: .barrier) {
            let entry = LogEntry(
                timestamp: Date(),
                level: level,
                message: message,
                category: category
            )
            
            self.logs.append(entry)
            
            // Keep only the last maxLogs entries
            if self.logs.count > self.maxLogs {
                self.logs.removeFirst(self.logs.count - self.maxLogs)
            }
            
            // Also print to console for Xcode debugging
            print("\(entry.level.color) [\(entry.formattedTimestamp)] \(entry.displayMessage)")
        }
    }
    
    /// Gets all logs (thread-safe)
    func getLogs() -> [LogEntry] {
        return queue.sync {
            return logs
        }
    }
    
    /// Clears all logs
    func clearLogs() {
        queue.async(flags: .barrier) {
            self.logs.removeAll()
        }
    }
    
    /// Gets logs as formatted string for sharing
    func getLogsAsString() -> String {
        return queue.sync {
            return logs.map { entry in
                "[\(entry.formattedTimestamp)] \(entry.level.rawValue) \(entry.displayMessage)"
            }.joined(separator: "\n")
        }
    }
}

/// Convenience logging functions
func logDebug(_ message: String, category: String? = nil) {
    #if DEBUG
    Logger.shared.log(message, level: .debug, category: category)
    #endif
}

func logInfo(_ message: String, category: String? = nil) {
    #if DEBUG
    Logger.shared.log(message, level: .info, category: category)
    #endif
}

func logWarning(_ message: String, category: String? = nil) {
    #if DEBUG
    Logger.shared.log(message, level: .warning, category: category)
    #endif
}

func logError(_ message: String, category: String? = nil) {
    #if DEBUG
    Logger.shared.log(message, level: .error, category: category)
    #endif
}
#endif

