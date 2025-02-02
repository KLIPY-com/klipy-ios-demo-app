struct MessageInputConfiguration {
    struct Layout {
        static let cornerRadius: CGFloat = 20
        static let buttonSize: CGFloat = 20
        static let contentSpacing: CGFloat = 12
        static let textFieldPadding: CGFloat = 12
        static let contentPadding = EdgeInsets(
            top: 8,
            leading: 16,
            bottom: 8,
            trailing: 16
        )
    }
    
    struct Colors {
        static let accent = Color(hex: "1E68D7")
        static let textFieldBackground = Color(.systemGray6)
        static let background = Color(red: 24/255, green: 28/255, blue: 31/255)
    }
    
    struct Animation {
        static let textField = SwiftUI.Animation.easeOut(duration: 0.2)
        static let sendButton = SwiftUI.Animation.spring(
            response: 0.3,
            dampingFraction: 0.6
        )
    }
}