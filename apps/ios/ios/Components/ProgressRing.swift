//
//  ProgressRing.swift
//  wellfin
//
//  ProgressRing component for circular progress indicators
//

import SwiftUI

struct WellfinProgressRing: View {
    let progress: Double // 0.0 to 1.0
    let lineWidth: CGFloat
    let color: Color
    var showPercentage: Bool = false
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    init(
        progress: Double,
        lineWidth: CGFloat = 8,
        color: Color = ColorToken.primary,
        showPercentage: Bool = false
    ) {
        self.progress = max(0, min(1, progress))
        self.lineWidth = lineWidth
        self.color = color
        self.showPercentage = showPercentage
    }
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(ColorToken.neutral200, lineWidth: lineWidth)
            
            // Progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(reduceMotion ? nil : MotionToken.standardEasing, value: progress)
            
            // Percentage text (optional)
            if showPercentage {
                Text("\(Int(progress * 100))%")
                    .font(TypographyToken.body(weight: .semibold))
                    .foregroundColor(ColorToken.text)
            }
        }
        .accessibilityLabel("Progress: \(Int(progress * 100)) percent")
        .accessibilityValue("\(Int(progress * 100))%")
    }
}

#Preview("Progress Rings") {
    VStack(spacing: SpacingToken.xl) {
        WellfinProgressRing(progress: 0.25, showPercentage: true)
            .frame(width: 80, height: 80)
        
        WellfinProgressRing(progress: 0.5, color: ColorToken.success, showPercentage: true)
            .frame(width: 80, height: 80)
        
        WellfinProgressRing(progress: 0.75, color: ColorToken.warning, showPercentage: true)
            .frame(width: 80, height: 80)
        
        WellfinProgressRing(progress: 1.0, color: ColorToken.danger, showPercentage: true)
            .frame(width: 80, height: 80)
    }
    .padding()
}

#Preview("Progress Ring Sizes") {
    HStack(spacing: SpacingToken.lg) {
        WellfinProgressRing(progress: 0.6, lineWidth: 4)
            .frame(width: 40, height: 40)
        
        WellfinProgressRing(progress: 0.6, lineWidth: 8)
            .frame(width: 80, height: 80)
        
        WellfinProgressRing(progress: 0.6, lineWidth: 12)
            .frame(width: 120, height: 120)
    }
    .padding()
}






