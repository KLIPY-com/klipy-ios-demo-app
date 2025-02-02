struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: action) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.blue)
                Spacer()
            }
            .padding(MenuConfiguration.Layout.itemPadding)
        }
    }
}