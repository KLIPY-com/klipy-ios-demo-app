struct ChatMessageConfiguration {
    struct Layout {
        static let cornerRadius: CGFloat = 16
        static let contentPadding = EdgeInsets(
            top: 12,
            leading: 12,
            bottom: 12,
            trailing: 12
        )
        static let messagePadding = EdgeInsets(
            top: 4,
            leading: 16,
            bottom: 4,
            trailing: 16
        )
    }
    
    struct Colors {
        static let userMessage = Color(hex: "1E68D7")
        static let otherMessage = Color(.systemGray6)
        static let messageText = Color.white
    }
}