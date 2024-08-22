import Foundation

class GraphQLService {
    private let url = URL(string: "https://m.stg.hilton.io/graphql/customer")!

    func performQuery(queryFileName: String, operationName: String, variables: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
        guard let queryURL = Bundle.main.url(forResource: queryFileName, withExtension: "graphql") else {
            completion(.failure(NSError(domain: "GraphQLServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Query file not found"])))
            return
        }

        do {
            let queryString = try String(contentsOf: queryURL, encoding: .utf8)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: Any] = [
                "query": queryString,
                "variables": variables,
                "operationName": operationName
            ]

            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Request error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Response Status: \(httpResponse.statusCode)")
                }

                guard let data = data else {
                    print("No data received")
                    completion(.failure(NSError(domain: "GraphQLServiceError", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }

                // Print raw data as a string for debugging
                if let rawDataString = String(data: data, encoding: .utf8) {
                    print("Raw Response Data: \(rawDataString)")
                }

                completion(.success(data))
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }

    // Method to fetch hotel IDs
    func fetchHotelIDs(location: String, language: String, completion: @escaping (Result<Data, Error>) -> Void) {
        performQuery(
            queryFileName: "GeocodeHotels",
            operationName: "geocode_hotelSummaryOptions",
            variables: [
                "address": location,
                "distanceUnit": "mi",
                "language": language,
                "placeId": "",
                "sessionToken": ""
            ]
        ) { result in
            completion(result)
        }
    }

    // Method to fetch hotel details
    func fetchHotelDetails(for hotelID: String, completion: @escaping (Result<Data, Error>) -> Void) {
        performQuery(
            queryFileName: "HotelDetailsQuery",
            operationName: "hotelDetails",
            variables: ["ctyhocn": hotelID, "language": "en"]
        ) { result in
            completion(result)
        }
    }
}
