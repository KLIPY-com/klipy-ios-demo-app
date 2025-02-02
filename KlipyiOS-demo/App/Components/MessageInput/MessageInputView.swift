struct MessageInputView: View {
    @Binding var messageText: String
    @FocusState var isFocused: Bool
    
    let onSendMessage: () -> Void
    let onMediaPickerTap: () -> Void
    
    private var isMessageEmpty: Bool {
        messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            inputContent
        }
    }
    
    private var inputContent: some View {
        HStack(spacing: MessageInputConfiguration.Layout.contentSpacing) {
            messageTextField
            mediaButton
            sendButton
        }
        .padding(MessageInputConfiguration.Layout.contentPadding)
        .background(MessageInputConfiguration.Colors.background)
    }
}