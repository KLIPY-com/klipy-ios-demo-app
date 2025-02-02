struct MenuConfiguration {
    struct Layout {
        static let menuWidth: CGFloat = 200
        static let mainMenuHeight: CGFloat = 100
        static let reportMenuHeight: CGFloat = 300
        static let cornerRadius: CGFloat = 14
        static let itemSpacing: CGFloat = 0
        static let itemPadding = EdgeInsets(
            top: 12,
            leading: 16,
            bottom: 12,
            trailing: 16
        )
    }
    
    struct Animation {
        static let duration: CGFloat = 0.3
        static let spring = SwiftUI.Animation.spring(duration: duration)
    }
}