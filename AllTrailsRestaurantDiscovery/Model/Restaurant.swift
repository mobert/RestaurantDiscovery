//
//  Restaurant.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 2/2/21.
//

import Foundation
import MapKit

class Restaurant: NSObject {
    
    let placeId: String?
    let location: CLLocation?
    let name: String?
    let imageRef: String?
    let numberOfReviews: Int?
    let rating: Double?
    let priceLevel: Int?
    let openNow: Bool?
    var isFavorite: Bool = false
    
    init(placeId: String?, latitude: Double?, longitude: Double?, name: String?, imageRef: String?, numberOfReviews: Int?, rating: Double?, priceLevel: Int?, openNow: Bool?) {
        location = CLLocation(latitude: latitude ?? 0, longitude: longitude ?? 0)
        self.placeId = placeId
        self.name = name
        self.imageRef = imageRef
        self.numberOfReviews = numberOfReviews
        self.rating = rating
        self.priceLevel = priceLevel
        self.openNow = openNow
        super.init()
    }
    
}

extension Restaurant: MKAnnotation {
  var coordinate: CLLocationCoordinate2D {
    get {
        guard let coordinate = location?.coordinate else { return CLLocationCoordinate2D(latitude: 0, longitude: 0)}
        return coordinate
    }
  }
  var title: String? {
    get {
      return name
    }
  }
}
