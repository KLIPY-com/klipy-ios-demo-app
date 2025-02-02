// MARK: - Unread Count Badge
private struct UnreadCountBadge: View {
    let count: Int
    let theme: ChatPreviewTheme
    
    var body: some View {
        ZStack {
            Circle()
                .fill(theme.colors.badge)
                .frame(
                    width: theme.sizes.badgeDiameter,
                    height: theme.sizes.badgeDiameter
                )
            
            Text("\(count)")
                .font(theme.fonts.badge)
                .bold()
                .foregroundColor(theme.colors.badgeText)
        }
    }
}