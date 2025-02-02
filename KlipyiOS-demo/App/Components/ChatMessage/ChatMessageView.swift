struct ChatMessageView: View {
    let message: Message
    let viewModel: ChatFeatureViewModel
    
    @State private var isPlaying: Bool = false
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
            }
            
            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading) {
                messageContent
                messageText
            }
            .padding(ChatMessageConfiguration.Layout.messagePadding)
            
            if !message.isFromCurrentUser {
                Spacer()
            }
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var messageContent: some View {
        if let mediaItem = message.mediaItem {
            if message.isMessageContaintsMp4 {
                VideoContentView(
                    mediaItem: mediaItem,
                    message: message,
                    viewModel: viewModel,
                    isPlaying: $isPlaying
                )
            } else {
                ImageContentView(mediaItem: mediaItem)
            }
        }
    }
    
    @ViewBuilder
    private var messageText: some View {
        if !message.content.isEmpty {
            Text(message.content)
                .padding(ChatMessageConfiguration.Layout.contentPadding)
                .background(
                    message.isFromCurrentUser ? 
                        ChatMessageConfiguration.Colors.userMessage :
                        ChatMessageConfiguration.Colors.otherMessage
                )
                .foregroundColor(ChatMessageConfiguration.Colors.messageText)
                .cornerRadius(ChatMessageConfiguration.Layout.cornerRadius)
        }
    }
}