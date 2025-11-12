//
//  Card.swift
//  wellfin
//
//  Card component for content containers
//

import SwiftUI

struct WellfinCard<Content: View>: View {
    let content: Content
    var elevation: ElevationToken = .raised
    
    init(elevation: ElevationToken = .raised, @ViewBuilder content: () -> Content) {
        self.elevation = elevation
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(SpacingToken.lg)
            .background(ColorToken.surface)
            .cardRadius()
            .elevation(elevation)
    }
}

#Preview("Card Examples") {
    ScrollView {
        VStack(spacing: SpacingToken.lg) {
            WellfinCard {
                VStack(alignment: .leading, spacing: SpacingToken.md) {
                    Text("Card Title")
                        .font(TypographyToken.headline())
                    Text("Card content goes here. This is a simple card example.")
                        .font(TypographyToken.body())
                        .foregroundColor(ColorToken.textSecondary)
                }
            }
            
            WellfinCard(elevation: .overlay) {
                VStack(alignment: .leading, spacing: SpacingToken.md) {
                    Text("Elevated Card")
                        .font(TypographyToken.headline())
                    Text("This card has overlay elevation.")
                        .font(TypographyToken.body())
                        .foregroundColor(ColorToken.textSecondary)
                }
            }
        }
        .padding()
    }
    .background(ColorToken.background)
}


