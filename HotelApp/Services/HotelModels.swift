import Foundation

// MARK: - HotelDetailsResponse
struct HotelDetailsResponse: Codable {
    let data: HotelData
}

// MARK: - HotelData
struct HotelData: Codable {
    let hotel: Hotel
}

// MARK: - Hotel
struct Hotel: Codable {
    let ctyhocn: String
    let name: String
    let contactInfo: ContactInfo
    let images: Images
    // Other properties can be added as needed
}

struct Images: Codable {
    let master: Master
}

struct Master: Codable {
    let url: String
}

// MARK: - ContactInfo
struct ContactInfo: Codable {
    let phoneNumber: String?
    let emailAddress1: String?
    let emailAddress2: String?
}

// MARK: - GeoCodeData
struct GeoCodeData: Codable {
    let data: GeoCodeResponse
}

// MARK: - GeoCodeResponse
struct GeoCodeResponse: Codable {
    let geocode: Geocode
}

// MARK: - Geocode
struct Geocode: Codable {
    let match: Match
    let ctyhocnList: CtyhocnList
}

// MARK: - Match
struct Match: Codable {
    let id: String
    let address: Address
    let name: String
    let type: String
    let geometry: Geometry
}

// MARK: - Address
struct Address: Codable {
    let city: String
    let country: String
    let state: String
}

// MARK: - Geometry
struct Geometry: Codable {
    let location: Location
    let bounds: Bounds
}

// MARK: - Location
struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

// MARK: - Bounds
struct Bounds: Codable {
    let northeast: Location
    let southwest: Location
}

// MARK: - CtyhocnList
struct CtyhocnList: Codable {
    let hotelList: [HotelID]
}

// MARK: - HotelID
struct HotelID: Codable {
    let ctyhocn: String
}
