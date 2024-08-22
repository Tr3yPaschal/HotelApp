import Foundation

class HotelsViewModel: ObservableObject {
    @Published var hotelNames: [String] = []
    @Published var hotels: [Hotel] = []

    private let graphqlService = GraphQLService()

    func fetchHotelIDs(location: String) {
        let variables: [String: Any] = [
            "address": location,
            "language": "en",
            "distanceUnit": "mi"
        ]
        graphqlService.performQuery(
            queryFileName: "GeocodeHotels",
            operationName: "geocodeHotels",
            variables: variables
        ) { [weak self] (result: Result<Data, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.parseHotelIDs(data: data)
            case .failure(let error):
                print("Failed to load hotel IDs: \(error)")
            }
        }
    }

    // Fetch hotel details for each hotel ID
    func fetchHotelDetails(hotelIDs: [String]) {
        hotels = [] // Clear previous hotel details
        for hotelID in hotelIDs {
            graphqlService.fetchHotelDetails(for: hotelID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.parseHotelDetails(data: data)
                case .failure(let error):
                    print("Failed to load hotel details: \(error)")
                }
            }
        }
    }

    private func loadHotelDetails(for hotelID: String) {
        graphqlService.performQuery(
            queryFileName: "HotelDetailsQuery",
            operationName: "hotel",
            variables: ["ctyhocn": hotelID, "language": "en"]
        ) { [weak self] (result: Result<Data, Error>) in
            guard let self = self else { return }
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
            let response = try decoder.decode(GeoCodeData.self, from: data)
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
            let hotel = response.data.hotel
            DispatchQueue.main.async { // Ensure updates happen on the main thread
                self.hotels.append(hotel)
                self.hotelNames.append(hotel.name)
            }
        } catch {
            print("Failed to decode hotel details: \(error)")
        }
    }
}
