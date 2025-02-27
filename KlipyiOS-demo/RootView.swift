//
//  RootView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 27.02.25.
//


//
//  UniversalOverlay.swift
//  UniversalView
//
//  Created by Balaji Venkatesh on 21/10/24.
//

import SwiftUI

extension View {
    @ViewBuilder
  func universalOverlay<Item: Identifiable & Equatable, Content: View>(
        animation: Animation = .snappy,
        item: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        self
            .modifier(UniversalOverlayItemModifier(animation: animation, item: item, viewContent: content))
    }
}

/// Root View Wrapper
struct RootView<Content: View>: View {
    var content: Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var properties = UniversalOverlayProperties()
    var body: some View {
        content
            .environment(properties)
            .onAppear {
                if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene), properties.window == nil {
                    let window = PassThroughWindow(windowScene: windowScene)
                    window.isHidden = false
                    window.isUserInteractionEnabled = true
                    /// Setting Up SwiftUI Based RootView Controller
                    let rootViewController = UIHostingController(rootView: UniversalOverlayViews().environment(properties))
                    rootViewController.view.backgroundColor = .clear
                    window.rootViewController = rootViewController
                    
                    properties.window = window
                }
            }
    }
}

/// Shared Universal Overlay Properties
@Observable
class UniversalOverlayProperties {
    var window: UIWindow?
    var views: [OverlayView] = []
    
    struct OverlayView: Identifiable {
        var id: String = UUID().uuidString
        var view: AnyView
    }
}

fileprivate struct UniversalOverlayItemModifier<Item: Identifiable & Equatable, ViewContent: View>: ViewModifier {
    var animation: Animation
    @Binding var item: Item?
    @ViewBuilder var viewContent: (Item) -> ViewContent
    
    /// Local View Properties
    @Environment(UniversalOverlayProperties.self) private var properties
    @State private var viewID: String?
    @State private var currentItem: Item?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: item) { oldValue, newValue in
                if let newValue {
                    addView(for: newValue)
                } else {
                    removeView()
                }
            }
    }
    
    private func addView(for item: Item) {
        if properties.window != nil {
            if viewID == nil {
                viewID = UUID().uuidString
            }
            
            guard let viewID else { return }
            currentItem = item
            
            // If the item already exists, remove it first to replace with the new view
            removeView()
            
            // Add the new view
            withAnimation(animation) {
                properties.views.append(.init(id: viewID, view: .init(viewContent(item))))
            }
        }
    }
    
    private func removeView() {
        if let viewID {
            withAnimation(animation) {
                properties.views.removeAll(where: { $0.id == viewID })
            }
            
            // Only clear the currentItem, keep the viewID in case we need to reuse it
            currentItem = nil
        }
    }
}

fileprivate struct UniversalOverlayViews: View {
    @Environment(UniversalOverlayProperties.self) private var properties
    var body: some View {
        ZStack {
            ForEach(properties.views) {
                $0.view
            }
        }
    }
}

fileprivate class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event),
                let rootView = rootViewController?.view
        else { return nil }
        
        if #available(iOS 18, *) {
            for subview in rootView.subviews.reversed() {
                /// Finding if any of rootview's is receving hit test
                let pointInSubView = subview.convert(point, from: rootView)
                if subview.hitTest(pointInSubView, with: event) != nil {
                    return hitView
                }
            }
            
            return nil
        } else {
            return hitView == rootView ? nil : hitView
        }
    }
}

#Preview {
    RootView {
        ContentView()
    }
}
