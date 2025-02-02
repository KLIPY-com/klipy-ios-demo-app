struct MediaSearchConfiguration {
    struct Layout {
        static let cornerRadius: CGFloat = 20
        static let categoryIconSize: CGFloat = 22
        static let controlSize: CGFloat = 24
        static let horizontalSpacing: CGFloat = 12
        static let categorySpacing: CGFloat = 16
        static let searchBarHeight: CGFloat = 28
        static let gradientWidth: CGFloat = 20
        static let categoriesWidth: CGFloat = 165
        
        static let contentPadding = EdgeInsets(
            top: 12,
            leading: 12,
            bottom: 12,
            trailing: 12
        )
    }
    
    struct Colors {
        static let background = Color(red: 24/255, green: 28/255, blue: 31/255)
        static let icon = Color.gray
        static let selectedIcon = Color.blue
        static let text = Color.white
    }
    
    struct Animation {
        static let categoryTransition = SwiftUI.Animation.default
        static let imageTransition = AnyTransition.fade(duration: 0.5)
    }
}