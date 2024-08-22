import Foundation

class GraphQLService {
    private let url = URL(string: "https://m.stg.hilton.io/graphql/customer")!

    func performQuery(queryFileName: String, variables: [String: Any], operationName: String? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let queryURL = Bundle.main.url(forResource: queryFileName, withExtension: "graphql") else {
            completion(.failure(NSError(domain: "GraphQLServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Query file not found"])))
            return
        }

        do {
            let queryString = try String(contentsOf: queryURL, encoding: .utf8)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            var body: [String: Any] = [
                "query": queryString,
                "variables": variables
            ]
            
            if let operationName = operationName {
                body["operationName"] = operationName
            }

            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "GraphQLServiceError", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }

                completion(.success(data))
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
