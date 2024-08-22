import Foundation
import Combine

class HotelDetailsViewModel: ObservableObject {
    @Published var hotel: HotelDetails?
    @Published var error: Error?

    private let graphQLService: GraphQLService

    init(hotelID: String, graphQLService: GraphQLService) {
        self.graphQLService = graphQLService
        fetchHotelDetails(hotelID: hotelID)
    }

    func fetchHotelDetails(hotelID: String) {
        let variables: [String: Any] = [
            "ctyhocn": hotelID,
            "language": "en"
        ]

        graphQLService.performQuery(queryFileName: "HotelDetailsQuery", operationName: "hotel", variables: variables) { [weak self] result in
            switch result {
            case .success(let data):
                if let hotelDetails = self?.parseHotelDetails(from: data) {
                    DispatchQueue.main.async {
                        self?.hotel = hotelDetails
                    }
                } else {
                    self?.handleError(NSError(domain: "HotelDetailsViewModelError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to parse hotel details"]))
                }
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }

    private func parseHotelDetails(from data: Data) -> HotelDetails? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            if let data = json?["data"] as? [String: Any],
               let hotel = data["hotel"] as? [String: Any],
               let id = hotel["id"] as? String,
               let name = hotel["name"] as? String {
                return HotelDetails(id: id, name: name)
            }
        } catch {
            print("Error parsing hotel details: \(error)")
        }
        return nil
    }

    private func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.error = error
        }
    }

    struct HotelDetails: Identifiable, Codable {
        let id: String
        let name: String
    }
}
