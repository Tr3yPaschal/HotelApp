import Foundation

class HotelsViewModel: ObservableObject {
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
            variables: variables,
            operationName: "geocodeHotels"
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.parseHotelIDs(data: data)
            case .failure(let error):
                print("Failed to load hotel IDs: \(error)")
            }
        }
    }

    func fetchHotelDetails(hotelIDs: [String]) {
        hotels = [] // Clear previous hotel details
        for hotelID in hotelIDs {
            let variables: [String: Any] = ["ctyhocn": hotelID, "language": "en"]

            graphqlService.performQuery(
                queryFileName: "HotelDetailsQuery",
                variables: variables,
                operationName: "hotel"
            ) { [weak self] result in
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

    private func parseHotelIDs(data: Data) {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GeoCodeData.self, from: data)
            let hotelIDs = response.data.geocode.ctyhocnList.hotelList.map { $0.ctyhocn }
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
                self.hotels.append(hotel)
            }
        } catch {
            print("Failed to decode hotel details: \(error)")
        }
    }
}
