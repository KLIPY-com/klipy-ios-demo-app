struct RowView: View {
  let row: RowLayout
  let isLastRow: Bool
  let onLoadMore: () -> Void
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      ForEach(row.items) { item in
        LazyGIFView(item: item)
          .frame(width: item.width, height: item.height)
          .offset(x: item.xPosition, y: 0)
          .onAppear {
            if isLastRow && item.id == row.items.last?.id {
              onLoadMore()
            }
          }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: row.height, alignment: .leading)
  }
}