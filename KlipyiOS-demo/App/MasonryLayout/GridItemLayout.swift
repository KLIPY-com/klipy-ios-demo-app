// MARK: - Layout Models
struct GridItemLayout: Identifiable {
    let id: Int64
    let url: String
    var width: CGFloat
    var height: CGFloat
    var xPosition: CGFloat = 0
    var yPosition: CGFloat = 0
    let originalWidth: CGFloat
    let originalHeight: CGFloat
    var newWidth: CGFloat = 0
    let type: String
}