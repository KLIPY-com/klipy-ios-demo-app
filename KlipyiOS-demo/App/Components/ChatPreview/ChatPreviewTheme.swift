//
//  ChatPreviewTheme.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//

import SwiftUI
import Foundation

// MARK: - Theme Structure
struct ChatPreviewTheme {
    let colors: Colors
    let fonts: Fonts
    let sizes: Sizes
    let spacing: Spacing
    
    static let `default` = ChatPreviewTheme(
        colors: .default,
        fonts: .default,
        sizes: .default,
        spacing: .default
    )
    
    struct Colors {
        let background: Color
        let avatarBackground: Color
        let avatarForeground: Color
        let onlineIndicator: Color
        let primaryText: Color
        let secondaryText: Color
        let badge: Color
        let badgeText: Color
        
        static let `default` = Colors(
            background: Color(red: 41/255, green: 46/255, blue: 50/255),
            avatarBackground: Color(.systemGray5),
            avatarForeground: .gray,
            onlineIndicator: .green,
            primaryText: Color(hex: "1E68D7"),
            secondaryText: .gray,
            badge: Color(hex: "1E68D7"),
            badgeText: .white
        )
    }
    
    struct Fonts {
        let name: Font
        let time: Font
        let message: Font
        let badge: Font
        
        static let `default` = Fonts(
            name: .headline,
            time: .caption,
            message: .subheadline,
            badge: .caption2
        )
    }
    
    struct Sizes {
        let avatarDiameter: CGFloat
        let avatarIconSize: CGFloat
        let onlineIndicatorDiameter: CGFloat
        let badgeDiameter: CGFloat
        
        static let `default` = Sizes(
            avatarDiameter: 50,
            avatarIconSize: 24,
            onlineIndicatorDiameter: 12,
            badgeDiameter: 20
        )
    }
    
    struct Spacing {
        let horizontal: CGFloat
        let vertical: CGFloat
        
        static let `default` = Spacing(
            horizontal: 12,
            vertical: 4
        )
    }
}
