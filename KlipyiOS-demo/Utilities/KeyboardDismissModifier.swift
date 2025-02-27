// Define a notification name
extension Notification.Name {
    static let dismissKeyboard = Notification.Name("dismissKeyboard")
}

// Create a view modifier
struct KeyboardDismissModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: .dismissKeyboard)) { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}

// Add it as a View extension
extension View {
    func dismissKeyboardOnNotification() -> some View {
        modifier(KeyboardDismissModifier())
    }
}