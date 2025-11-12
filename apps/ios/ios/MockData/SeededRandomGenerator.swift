//
//  SeededRandomGenerator.swift
//  wellfin
//
//  Created on 2025/11/12.
//

import Foundation

/// A deterministic random number generator using a seed for reproducible mock data
struct SeededRandomGenerator {
    private var state: UInt64
    
    init(seed: UInt64) {
        self.state = seed
    }
    
    /// Generates the next random number in the sequence
    mutating func next() -> UInt64 {
        // Linear congruential generator (LCG) for deterministic randomness
        // Using constants from Numerical Recipes
        state = (state &* 1664525 &+ 1013904223) & UInt64.max
        return state
    }
    
    /// Returns a random integer in the range [0, upperBound)
    mutating func nextInt(upperBound: Int) -> Int {
        guard upperBound > 0 else { return 0 }
        return Int(next() % UInt64(upperBound))
    }
    
    /// Returns a random integer in the range [lowerBound, upperBound)
    mutating func nextInt(lowerBound: Int, upperBound: Int) -> Int {
        let range = upperBound - lowerBound
        guard range > 0 else { return lowerBound }
        return lowerBound + nextInt(upperBound: range)
    }
    
    /// Returns a random double in the range [0.0, 1.0)
    mutating func nextDouble() -> Double {
        return Double(next()) / Double(UInt64.max)
    }
    
    /// Returns a random double in the range [lowerBound, upperBound)
    mutating func nextDouble(lowerBound: Double, upperBound: Double) -> Double {
        let range = upperBound - lowerBound
        return lowerBound + nextDouble() * range
    }
    
    /// Returns a random boolean
    mutating func nextBool() -> Bool {
        return nextInt(upperBound: 2) == 0
    }
    
    /// Returns a random element from the array
    mutating func randomElement<T>(from array: [T]) -> T? {
        guard !array.isEmpty else { return nil }
        return array[nextInt(upperBound: array.count)]
    }
    
    /// Shuffles an array deterministically
    mutating func shuffled<T>(_ array: [T]) -> [T] {
        var result = array
        var gen = self
        for i in stride(from: result.count - 1, through: 1, by: -1) {
            let j = gen.nextInt(upperBound: i + 1)
            result.swapAt(i, j)
        }
        return result
    }
}



