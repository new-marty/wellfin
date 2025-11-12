//
//  ListRow.swift
//  wellfin
//
//  ListRow component for list items
//

import SwiftUI

struct WellfinListRow<Leading: View, Trailing: View>: View {
    let leading: Leading
    let trailing: Trailing
    var action: (() -> Void)? = nil
    
    init(
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing,
        action: (() -> Void)? = nil
    ) {
        self.leading = leading()
        self.trailing = trailing()
        self.action = action
    }
    
    var body: some View {
        if let action = action {
            Button(action: action) {
                content
            }
            .buttonStyle(.plain)
        } else {
            content
        }
    }
    
    private var content: some View {
        HStack(spacing: SpacingToken.md) {
            leading
            Spacer()
            trailing
        }
        .padding(.vertical, SpacingToken.sm)
        .padding(.horizontal, SpacingToken.lg)
        .contentShape(Rectangle())
    }
}

// Convenience initializer for simple text rows
extension WellfinListRow where Leading == Text, Trailing == EmptyView {
    init(title: String, action: (() -> Void)? = nil) {
        self.leading = Text(title)
            .font(TypographyToken.body())
            .foregroundColor(ColorToken.text)
        self.trailing = EmptyView()
        self.action = action
    }
}

// Convenience initializer with trailing view
extension WellfinListRow where Leading == Text {
    init(title: String, @ViewBuilder trailing: () -> Trailing, action: (() -> Void)? = nil) {
        self.leading = Text(title)
            .font(TypographyToken.body())
            .foregroundColor(ColorToken.text)
        self.trailing = trailing()
        self.action = action
    }
}

#Preview("List Rows") {
    List {
        WellfinListRow(title: "Simple Row") {}
        
        WellfinListRow(title: "Row with Trailing") {
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(ColorToken.textSubtle)
        } action: {}
        
        WellfinListRow {
            VStack(alignment: .leading, spacing: SpacingToken.xs) {
                Text("Title")
                    .font(TypographyToken.body(weight: .semibold))
                Text("Subtitle")
                    .font(TypographyToken.footnote())
                    .foregroundColor(ColorToken.textSecondary)
            }
        } trailing: {
            Text("$123.45")
                .font(TypographyToken.body(weight: .semibold))
        } action: {}
    }
    .listStyle(.plain)
}


