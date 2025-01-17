import SwiftUI

fileprivate struct MenuButtonView: View {
    
    var body: some View {
        MenuButton(color: .white)
            .frame(width: 20, height: 20, alignment: .center)
    }
}

public struct MenuButton: View {
    
    var color: UIColor
    @State private var isAnimating: Bool = false
    
    public var body: some View {
        Button(action: {
            self.isAnimating.toggle()
        }, label: {
            createMenu()
                .frame(width: 20, height: 20, alignment: .center)
                .foregroundColor(Color(color))
        })
    }
    
    func createMenu() -> AnyView {
        let count = 4
        let indicator = GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<count) { index in
                Group { () -> AnyView in
                    let availableHeight = geometry.size.height / CGFloat(count)
                    let spacing = availableHeight / CGFloat(count - 1)
                    let height = availableHeight - spacing
                    let width = geometry.size.width
                    
                    let rect = RoundedRectangle(cornerRadius: 2)
                        .frame(width: width, height: height)
                    return AnyView(
                        rect
                            .offset(y: availableHeight * CGFloat(index))
                            .animateMiddleRect(
                                at: index,
                                isAnimating: self.isAnimating,
                                width: width,
                                spacing: spacing)
                            .animateMarginRect(at: index, isAnimating: self.isAnimating)
                            .animation(
                                Animation.easeInOut
                                    .delay(0.2))
                        
                    )
                }
            }
        }
        return AnyView(indicator)
    }
}

struct MiddleMenuRect: ViewModifier {
    
    let isAnimating: Bool
    let index: Int
    let width: CGFloat
    let spacing: CGFloat
    
    init(at index: Int, isAnimating: Bool, width: CGFloat, spacing: CGFloat) {
        self.index = index
        self.isAnimating = isAnimating
        self.width = width
        self.spacing = spacing
    }
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(rotate(index))
            .offset(adjust(index, xValue: width / 4, yValue: spacing))
    }
    
    private func adjust(_ rect: Int, xValue: CGFloat, yValue: CGFloat) -> CGSize {
        let condition = validateMiddle(rect)
        var offsetX: CGFloat = 0.0
        var offsetY: CGFloat = 0.0
        
        switch rect {
        case 1:
            offsetX = condition ? xValue : 0.0
            offsetY = condition ? yValue : 0.0
        case 2:
            offsetX = condition ? -xValue : 0.0
            offsetY = condition ? -yValue : 0.0
        default: break
        }
        
        return CGSize(width: offsetX, height: offsetY)
    }
    
    private func rotate(_ rect: Int) -> Angle {
        let condition = validateMiddle(rect)
        var degrees: Double = 0.0
        
        switch rect {
        case 1:
            degrees = condition ? 45.0 : 0.0
        case 2:
            degrees = condition ? -45.0 : 0.0
        default: degrees = 0.0
        }
        return Angle(degrees: degrees)
    }
    
    private func validateMiddle(_ rect: Int) -> Bool {
        (rect == 1 || rect == 2) && isAnimating
    }
}

struct MarginMenuRect: ViewModifier {
    
    let isAnimating: Bool
    let index: Int
    
    init(at index: Int, isAnimating: Bool) {
        self.index = index
        self.isAnimating = isAnimating
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: remove(index))
            .opacity(fade(index))
    }
    
    private func fade(_ rect: Int) -> Double {
        let condition = validateMargin(rect)
        switch rect {
        case 0:
            return condition ? 0.0 : 1.0
        case 3:
            return condition ? 0.0 : 1.0
        default: return 1
        }
    }
    
    private func remove(_ rect: Int) -> CGFloat {
        let condition = validateMargin(rect)
        switch rect {
        case 0:
            return condition ? 20 : 0
        case 3:
            return condition ? -20 : 0
        default: return 0
        }
    }
    
    private func validateMargin(_ rect: Int) -> Bool {
        (rect == 0 || rect == 3) && isAnimating
    }
}

extension View {
    func animateMarginRect(at index: Int, isAnimating: Bool) -> some View {
        return self.modifier(
            MarginMenuRect(at: index,
                           isAnimating: isAnimating))
    }
    
    func animateMiddleRect(at index: Int, isAnimating: Bool, width: CGFloat, spacing: CGFloat) -> some View {
        return self.modifier(
            MiddleMenuRect(at: index,
                           isAnimating: isAnimating,
                           width: width,
                           spacing: spacing))
    }
}

#if DEBUG
struct MenuAnimation_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView()
            .frame(width: 100, height: 100, alignment: .center)
            .background(Color(.appRed))
    }
}
#endif