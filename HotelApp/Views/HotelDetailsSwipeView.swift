import SwiftUI

struct HotelDetailsSwipeView: View {
    @ObservedObject var viewModel: HotelsViewModel

    var body: some View {
        TabView {
            ForEach(viewModel.hotels, id: \.ctyhocn) { hotel in
                VStack(alignment: .leading, spacing: 10) {
                    // Placeholder image
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: UIScreen.main.bounds.height / 4)
                        .clipped()
                    
                    Text(hotel.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .padding(.horizontal)
                    
                    if let phoneNumber = hotel.contactInfo.phoneNumber {
                        Text("Phone: \(phoneNumber)")
                            .font(.body)
                            .padding(.horizontal)
                    }

                    Spacer()
                }
                .foregroundColor(.white) // Set text color to white
                .background(Color.black) // Set background color to black
                .edgesIgnoringSafeArea(.all) // Ensure background covers the entire screen
            }
        }
        .tabViewStyle(PageTabViewStyle()) // Enables swipe pagination
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Set overall background to black
    }
}
