import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct MediaSearchBar: View {
    @Binding var searchText: String
    @Binding var selectedCategory: MediaCategory?
    let categories: [MediaCategory]
    
    var body: some View {
        ZStack {
            MediaSearchConfiguration.Colors.background
            
            HStack(spacing: MediaSearchConfiguration.Layout.horizontalSpacing) {
                navigationControl
                searchField
                clearButton
                categoriesView
            }
        }
        .frame(height: MediaSearchConfiguration.Layout.searchBarHeight)
        .padding(MediaSearchConfiguration.Layout.contentPadding)
        .background(MediaSearchConfiguration.Colors.background)
        .cornerRadius(MediaSearchConfiguration.Layout.cornerRadius)
    }
}