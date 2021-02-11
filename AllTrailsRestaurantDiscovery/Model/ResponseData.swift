//
//  ResponseData.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 2/2/21.
//

struct Response: Codable {
    let htmlAttributions : [String]?
    let nextPageToken : String?
    let results : [Place]?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case htmlAttributions = "html_attributions"
        case nextPageToken = "next_page_token"
        case results = "results"
        case status = "status"
    }
}


struct Place : Codable {
    let businessStatus : String?
    let geometry : Geometry?
    let icon : String?
    let name : String?
    let obfuscatedType : [String]?
    let openingHours : OpeningHours?
    let photos : [Photos]?
    let placeId : String?
    let plusCode : PlusCode?
    let priceLevel: Int?
    let rating : Double?
    let reference : String?
    let scope : String?
    let types : [String]?
    let userRatingsTotal : Int?
    let vicinity : String?

    enum CodingKeys: String, CodingKey {

        case businessStatus = "business_status"
        case geometry = "geometry"
        case icon = "icon"
        case name = "name"
        case obfuscatedType = "obfuscated_type"
        case openingHours = "opening_hours"
        case photos = "photos"
        case placeId = "place_id"
        case plusCode = "plus_code"
        case priceLevel = "price_level"
        case rating = "rating"
        case reference = "reference"
        case scope = "scope"
        case types = "types"
        case userRatingsTotal = "user_ratings_total"
        case vicinity = "vicinity"
    }
}


struct Location: Codable {
    let lat: Double?
    let lng: Double?

    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
}

struct Photos : Codable {
    let height : Int?
    let htmlAttributions : [String]?
    let photoReference : String?
    let width : Int?

    enum CodingKeys: String, CodingKey {

        case height = "height"
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width = "width"
    }
}

struct Geometry: Codable {
    let location: Location?
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
    }
}


struct OpeningHours : Codable {
    let openNow : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case openNow = "open_now"
    }
}

struct PlusCode : Codable {
    let compoundCode : String?
    let globalCode : String?

    enum CodingKeys: String, CodingKey {

        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }

}
