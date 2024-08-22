import SwiftUI

class HotelsViewModel: ObservableObject {
    @Published var hotelNames: [String] = []

    private let graphqlService = GraphQLService()

    func fetchHotelIDs(location: String) {
        let variables: [String: Any] = ["location": location, "language": "en"]
        graphqlService.performQuery(
            queryFileName: "GeoCodeHotelsQuery",
            operationName: "geocode_hotelSummaryOptions",
            variables: variables
        ) { result in
            switch result {
            case .success(let data):
                self.parseHotelIDs(data: data)
            case .failure(let error):
                print("Failed to load hotel IDs: \(error)")
            }
        }
    }

    // Changed to internal (default access level) for use in ContentView
    func fetchHotelDetails(hotelIDs: [String]) {
        hotelNames = [] // Clear previous names
        for hotelID in hotelIDs {
            loadHotelDetails(for: hotelID)
        }
    }

    private func loadHotelDetails(for hotelID: String) {
        graphqlService.performQuery(
            queryFileName: "HotelDetailsQuery",
            operationName: "hotel",
            variables: ["ctyhocn": hotelID, "language": "en"]
        ) { result in
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
            let response = try decoder.decode(GeoCodeHotelsResponse.self, from: data)
            let hotelIDs = response.data.geocode.ctyhocnList.hotelList.prefix(3).map { $0.ctyhocn }
            fetchHotelDetails(hotelIDs: Array(hotelIDs))
        } catch {
            print("Failed to decode hotel IDs: \(error)")
        }
    }

    private func parseHotelDetails(data: Data) {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(HotelDetailsResponse.self, from: data)
            let name = response.data.hotel.name
            DispatchQueue.main.async {
                self.hotelNames.append(name)
            }
        } catch {
            print("Failed to decode hotel details: \(error)")
        }
    }
}
