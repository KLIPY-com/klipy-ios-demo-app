import SwiftUI

struct MenuButton: View {
    let icon: String
    let title: String
    var trailingIcon: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
                Spacer()
                if let trailingIcon {
                    Image(systemName: trailingIcon)
                }
            }
            .foregroundColor(.primary)
            .padding(MenuConfiguration.Layout.itemPadding)
        }
    }
}