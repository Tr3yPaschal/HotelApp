import SwiftUI

struct HotelDetailsSwipeView: View {
    @ObservedObject var viewModel: HotelsViewModel

    var body: some View {
        TabView {
            ForEach(viewModel.hotels, id: \.ctyhocn) { hotel in
                VStack(alignment: .leading, spacing: 10) {
                    if let imageUrl = URL(string: hotel.images.master.url) {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: UIScreen.main.bounds.height / 4)
                                .clipped()
                        } placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: UIScreen.main.bounds.height / 4)
                                .clipped()
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: UIScreen.main.bounds.height / 4)
                            .clipped()
                    }

                    
                    Text(hotel.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .padding(.horizontal)
                    
                    if let phoneNumber = hotel.contactInfo.phoneNumber {
                        Text("Phone: \(phoneNumber)")
                            .font(.subheadline)
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
