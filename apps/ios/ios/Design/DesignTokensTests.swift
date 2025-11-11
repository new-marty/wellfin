//
//  DesignTokensTests.swift
//  wellfin
//
//  Unit tests for design tokens
//

import XCTest
import SwiftUI

final class DesignTokensTests: XCTestCase {
    
    // MARK: - Spacing Token Tests
    
    func testSpacingTokens() {
        XCTAssertEqual(SpacingToken.zero, 0)
        XCTAssertEqual(SpacingToken.xs, 4)
        XCTAssertEqual(SpacingToken.sm, 8)
        XCTAssertEqual(SpacingToken.md, 12)
        XCTAssertEqual(SpacingToken.lg, 16)
        XCTAssertEqual(SpacingToken.xl, 20)
        XCTAssertEqual(SpacingToken.xxl, 24)
        XCTAssertEqual(SpacingToken.xxxl, 32)
    }
    
    // MARK: - Radius Token Tests
    
    func testRadiusTokens() {
        XCTAssertEqual(RadiusToken.chip, 4)
        XCTAssertEqual(RadiusToken.card, 8)
        XCTAssertEqual(RadiusToken.modal, 12)
    }
    
    // MARK: - Elevation Token Tests
    
    func testElevationNone() {
        let elevation = ElevationToken.none
        XCTAssertEqual(elevation.shadowRadius, 0)
        XCTAssertEqual(elevation.shadowOpacity, 0)
        XCTAssertEqual(elevation.shadowOffset, .zero)
    }
    
    func testElevationRaised() {
        let elevation = ElevationToken.raised
        XCTAssertEqual(elevation.shadowRadius, 2)
        XCTAssertEqual(elevation.shadowOpacity, 0.1)
        XCTAssertEqual(elevation.shadowOffset.height, 1)
    }
    
    func testElevationOverlay() {
        let elevation = ElevationToken.overlay
        XCTAssertEqual(elevation.shadowRadius, 8)
        XCTAssertEqual(elevation.shadowOpacity, 0.2)
        XCTAssertEqual(elevation.shadowOffset.height, 4)
    }
    
    // MARK: - Motion Token Tests
    
    func testMotionDurations() {
        XCTAssertEqual(MotionToken.fast, 0.12, accuracy: 0.01)
        XCTAssertEqual(MotionToken.standard, 0.2, accuracy: 0.01)
        XCTAssertEqual(MotionToken.slow, 0.22, accuracy: 0.01)
    }
    
    // MARK: - Typography Token Tests
    
    func testTypographyTokensExist() {
        // Verify that typography tokens can be created
        let largeTitle = TypographyToken.largeTitle()
        let title = TypographyToken.title()
        let headline = TypographyToken.headline()
        let body = TypographyToken.body()
        let footnote = TypographyToken.footnote()
        let caption = TypographyToken.caption()
        
        // Basic existence check - fonts should be created
        XCTAssertNotNil(largeTitle)
        XCTAssertNotNil(title)
        XCTAssertNotNil(headline)
        XCTAssertNotNil(body)
        XCTAssertNotNil(footnote)
        XCTAssertNotNil(caption)
    }
    
    func testTabularNumbers() {
        let bodyFont = TypographyToken.body()
        let tabularFont = TypographyToken.tabularNumbers(bodyFont)
        // Tabular numbers should return a monospaced digit font
        XCTAssertNotNil(tabularFont)
    }
}

