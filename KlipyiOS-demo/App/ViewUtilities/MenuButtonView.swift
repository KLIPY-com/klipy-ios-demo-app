import SwiftUI

struct CustomMenuView: View {
    let menuItems: [MenuItem]
    @Binding var isPresented: Bool
    let anchorPoint: CGPoint
    
    var body: some View {
        if isPresented {
            ZStack {
                // Backdrop
                Color.black.opacity(0.01)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                    }
                
                // Menu content
                VStack(spacing: 0) {
                    ForEach(menuItems) { item in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isPresented = false
                                item.action()
                            }
                        }) {
                            HStack {
                                Text(item.title)
                                    .foregroundColor(.primary)
                                Spacer()
                                item.icon
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        
                        if item.id != menuItems.last?.id {
                            Divider()
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 5)
                )
                .frame(width: 200)
                .position(x: anchorPoint.x, y: anchorPoint.y)
            }
            .transition(.opacity)
        }
    }
}

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: Image
    let action: () -> Void
}

struct Test: View {
    @State private var isMenuPresented = false
    @State private var menuPosition: CGPoint = .zero
    
    let menuItems = [
        MenuItem(
            title: "Menu Item 1",
            icon: Image(systemName: "command"),
            action: { print("Action 1") }
        ),
        MenuItem(
            title: "Menu Item 2",
            icon: Image(systemName: "option"),
            action: { print("Action 2") }
        ),
        MenuItem(
            title: "Menu Item 3",
            icon: Image(systemName: "shift"),
            action: { print("Action 3") }
        )
    ]
    
    var body: some View {
        List {
            HStack {
                Text("Cell content")
                Spacer()
                
                Image(systemName: "ellipsis")
                    .imageScale(.large)
                    .padding()
                    .background(GeometryReader { geometry in
                        Color.clear.onAppear {
                            let frame = geometry.frame(in: .global)
                            menuPosition = CGPoint(x: frame.midX, y: frame.midY)
                        }
                    })
            }
            .contentShape(Rectangle())
            .onTapGesture {
                print("Cell tapped")
            }
        }
        .overlay {
            CustomMenuView(
                menuItems: menuItems,
                isPresented: $isMenuPresented,
                anchorPoint: menuPosition
            )
        }
        .onAppear {
            // Auto trigger the menu
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isMenuPresented = true
                }
            }
        }
    }
}

#Preview {
    Test()
}
