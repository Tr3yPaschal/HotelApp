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

struct Images: Codable{
    let master : Master
}

struct Master: Codable{
    let url : String
}

// MARK: - ContactInfo
struct ContactInfo: Codable {
    let phoneNumber: String?
    let emailAddress1: String?
    let emailAddress2: String?
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
