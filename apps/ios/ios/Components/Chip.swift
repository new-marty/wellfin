//
//  Chip.swift
//  wellfin
//
//  Chip component for selectable/filter chips
//

import SwiftUI

enum ChipStyle {
    case selectable
    case filter
}

struct WellfinChip: View {
    let title: String
    let style: ChipStyle
    @Binding var isSelected: Bool
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
            onTap?()
        }) {
            HStack(spacing: SpacingToken.xs) {
                Text(title)
                    .font(TypographyToken.caption(weight: .medium))
                
                if style == .filter && isSelected {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 12))
                }
            }
            .padding(.horizontal, SpacingToken.sm)
            .padding(.vertical, SpacingToken.xs)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: RadiusToken.chip)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .cornerRadius(RadiusToken.chip)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityHint("Double tap to \(isSelected ? "deselect" : "select")")
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return ColorToken.primary.opacity(0.1)
        }
        return ColorToken.surface
    }
    
    private var foregroundColor: Color {
        if isSelected {
            return ColorToken.primary
        }
        return ColorToken.text
    }
    
    private var borderColor: Color {
        if isSelected {
            return ColorToken.primary
        }
        return ColorToken.border
    }
    
    private var borderWidth: CGFloat {
        isSelected ? 1.5 : 1
    }
}

#Preview("Selectable Chips") {
    VStack(spacing: SpacingToken.md) {
        HStack(spacing: SpacingToken.sm) {
            WellfinChip(title: "Option 1", style: .selectable, isSelected: .constant(true)) {}
            WellfinChip(title: "Option 2", style: .selectable, isSelected: .constant(false)) {}
            WellfinChip(title: "Option 3", style: .selectable, isSelected: .constant(true)) {}
        }
    }
    .padding()
}

#Preview("Filter Chips") {
    VStack(spacing: SpacingToken.md) {
        HStack(spacing: SpacingToken.sm) {
            WellfinChip(title: "Food", style: .filter, isSelected: .constant(true)) {}
            WellfinChip(title: "Transport", style: .filter, isSelected: .constant(false)) {}
            WellfinChip(title: "Shopping", style: .filter, isSelected: .constant(true)) {}
        }
    }
    .padding()
}


