// MARK: - Masonry Grid View
struct MasonryGridView: View {
    let rows: [RowLayout]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(rows.indices, id: \.self) { rowIndex in
                    ForEach(rows[rowIndex].items) { item in
                        GIFImage(source: .remoteURL(URL(string: item.url)!))
                            .frame(width: item.width, height: item.height)
                            .position(x: item.xPosition + item.width/2,
                                    y: item.yPosition + item.height/2)
                    }
                }
            }
        }
    }
}