private struct ChatInfoView: View {
    let model: ChatPreviewModel
    let theme: ChatPreviewTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.vertical) {
            HStack {
                Text(model.name)
                    .font(theme.fonts.name)
                
                Spacer()
                
                Text(model.time)
                    .font(theme.fonts.time)
                    .foregroundColor(theme.colors.secondaryText)
            }
            
            HStack {
                Text(model.lastMessage)
                    .font(theme.fonts.message)
                    .foregroundColor(theme.colors.primaryText)
                    .lineLimit(1)
                
                if model.unreadCount > 0 {
                    Spacer()
                    UnreadCountBadge(
                        count: model.unreadCount,
                        theme: theme
                    )
                }
            }
        }
    }
}