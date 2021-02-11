//
//  QueryParameters.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 2/2/21.
//

import Foundation

struct QueryParameters {
    var location: LocationParameters?
    var nextPageToken: String?
}

struct LocationParameters {
    var latitude: String
    var longitude: String
    var radius: String
}






