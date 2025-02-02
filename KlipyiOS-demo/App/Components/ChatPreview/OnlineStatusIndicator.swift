// MARK: - Online Status Indicator
private struct OnlineStatusIndicator: View {
    let theme: ChatPreviewTheme
    
    var body: some View {
        Circle()
            .fill(theme.colors.onlineIndicator)
            .frame(
                width: theme.sizes.onlineIndicatorDiameter,
                height: theme.sizes.onlineIndicatorDiameter
            )
            .overlay(
                Circle()
                    .stroke(theme.colors.background, lineWidth: 2)
            )
    }
}