import SwiftUI

struct HotelDetailsSwipeView: View {
    @ObservedObject var viewModel: HotelsViewModel

    var body: some View {
        TabView {
            ForEach(viewModel.hotelNames, id: \.self) { hotelName in
                Text(hotelName)
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white) // Set text color to white
                    .background(Color.black) // Set background color to black
                    .edgesIgnoringSafeArea(.all) // Ensure background covers the entire screen
            }
        }
        .tabViewStyle(PageTabViewStyle()) // Enables swipe pagination
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Set overall background to black
    }
}
