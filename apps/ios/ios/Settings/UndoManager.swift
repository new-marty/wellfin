//
//  UndoManager.swift
//  wellfin
//
//  Created on 2025/11/12.
//
//  Undo manager for reversible edits

import Foundation

#if DEBUG
/// Represents an undoable action
struct UndoableAction {
    let id = UUID()
    let description: String
    let undo: () -> Void
    let timestamp: Date
    
    init(description: String, undo: @escaping () -> Void) {
        self.description = description
        self.undo = undo
        self.timestamp = Date()
    }
}

/// Manages undo stack for reversible edits
@Observable
final class UndoManager {
    static let shared = UndoManager()
    
    private var undoStack: [UndoableAction] = []
    private let maxStackSize = 50
    
    private init() {}
    
    /// Registers an undoable action
    func register(_ action: UndoableAction) {
        undoStack.append(action)
        
        // Limit stack size
        if undoStack.count > maxStackSize {
            undoStack.removeFirst()
        }
        
        logInfo("Undo action registered: \(action.description)", category: "Undo")
    }
    
    /// Performs undo of the last action
    func undo() -> Bool {
        guard let lastAction = undoStack.popLast() else {
            return false
        }
        
        lastAction.undo()
        logInfo("Undo performed: \(lastAction.description)", category: "Undo")
        return true
    }
    
    /// Gets the description of the last undoable action
    func lastActionDescription() -> String? {
        return undoStack.last?.description
    }
    
    /// Checks if there are any undoable actions
    func canUndo() -> Bool {
        return !undoStack.isEmpty
    }
    
    /// Clears the undo stack
    func clear() {
        undoStack.removeAll()
    }
}
#endif

