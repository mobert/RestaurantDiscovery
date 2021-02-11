//
//  RestaurantDiscoveryAlerts.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 2/2/21.
//

import UIKit

class RestaurantDiscoveryAlerts {
    
    static let title = "Error"
    static let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
    class func getAlertController(for error: NetworkError) -> UIAlertController {
        switch error {
        case .urlError:
            return RestaurantDiscoveryAlerts.serverError()
        case .decodingError, .searchTerm, .badURL:
            return RestaurantDiscoveryAlerts.genericError()
        }
    }
    
    // network monitor alert
    class func networkError() -> UIAlertController {
        let message = "Oops! Restaurant Discoverer requires an internet connection. Please check your connection and try again."
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(action)
        return controller
    }
    
    // show for OVER_QUERY_LIMIT, REQUEST_DENIED, INVALID_REQUEST (unless it is a next page request, for this we will try again)
    private class func genericError() -> UIAlertController {
        let message = "Oops! There was a problem loading restaurant data."
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(action)
        return controller
    }
    
    class func noResultsError() -> UIAlertController {
        let message = "Oops! There are no results that match your search."
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(action)
        return controller
    }
    
    private class func serverError() -> UIAlertController {
        let message = "Oops! The servers bonked. Please try again"
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(action)
        return controller
    }
    
    class func locationError() -> UIAlertController {
        let message = "Oops! There was a problem fetching your location."
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return controller
    }
    
    
}
