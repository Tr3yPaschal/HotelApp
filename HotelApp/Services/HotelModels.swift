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
    // Other properties can be added as needed
}

// MARK: - GeoCodeHotelsResponse
struct GeoCodeHotelsResponse: Codable {
    let data: GeoCodeData
}

// MARK: - GeoCodeData
struct GeoCodeData: Codable {
    let geocode: Geocode
}

// MARK: - Geocode
struct Geocode: Codable {
    let ctyhocnList: HotelList
}

// MARK: - HotelList
struct HotelList: Codable {
    let hotelList: [HotelID]
}

// MARK: - HotelID
struct HotelID: Codable {
    let ctyhocn: String
}
