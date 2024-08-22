import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HotelsViewModel()
    @State private var searchText: String = ""

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                TextField("Enter location", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                    .frame(height: 44) // Match height with the button
                    .background(Color.white) // Background of the text field

                Button(action: {
                    viewModel.fetchHotelIDs(location: searchText)
                }) {
                    Image(systemName: "magnifyingglass")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44) // Match height with the TextField
                }
            }
            .background(Color.black) // Background color behind the controls
            .cornerRadius(8) // Optional: Rounded corners for the combined control
            .padding()

            HotelDetailsSwipeView(viewModel: viewModel)
                .onAppear {
                    viewModel.fetchHotelIDs(location: "Chicago") // Default location
                }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Set overall background to white
    }
}
