import Foundation

class HotelsViewModel: ObservableObject {
    @Published var hotelNames: [String] = []
    @Published var hotels: [Hotel] = [] // Add this line to hold hotel details

    private let graphqlService = GraphQLService()

    func fetchHotelIDs(location: String) {
        let variables: [String: Any] = ["location": location, "language": "en"]
        graphqlService.performQuery(
            queryFileName: "GeoCodeHotelsQuery",
            operationName: "geocode_hotelSummaryOptions",
            variables: variables
        ) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                self.parseHotelIDs(data: data)
            case .failure(let error):
                print("Failed to load hotel IDs: \(error)")
            }
        }
    }

    func fetchHotelDetails(hotelIDs: [String]) {
        hotelNames = [] // Clear previous names
        hotels = [] // Clear previous hotel details
        for hotelID in hotelIDs {
            loadHotelDetails(for: hotelID)
        }
    }

    private func loadHotelDetails(for hotelID: String) {
        graphqlService.performQuery(
            queryFileName: "HotelDetailsQuery",
            operationName: "hotel",
            variables: ["ctyhocn": hotelID, "language": "en"]
        ) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                self.parseHotelDetails(data: data)
            case .failure(let error):
                print("Failed to load hotel details: \(error)")
            }
        }
    }

    private func parseHotelIDs(data: Data) {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GeoCodeData.self, from: data) // Update to GeoCodeData
            let hotelIDs = response.geocode.ctyhocnList.hotelList.prefix(3).map { $0.ctyhocn }
            fetchHotelDetails(hotelIDs: Array(hotelIDs))
        } catch {
            print("Failed to decode hotel IDs: \(error)")
        }
    }

    private func parseHotelDetails(data: Data) {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(HotelDetailsResponse.self, from: data)
            let hotel = response.data.hotel
            DispatchQueue.main.async {
                self.hotels.append(hotel) // Update to use the hotels array
                self.hotelNames.append(hotel.name)
            }
        } catch {
            print("Failed to decode hotel details: \(error)")
        }
    }
}
