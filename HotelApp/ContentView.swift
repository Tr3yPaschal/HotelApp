import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HotelsViewModel()

    var body: some View {
        HotelDetailsSwipeView(viewModel: viewModel)
            .onAppear {
                viewModel.fetchHotelIDs(location: "Denver") // Fetch hotel IDs for Denver
            }
    }
}
