//
//  PlaceDecoder.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 2/2/21.
//

import Foundation

struct PlaceDecoder {
    
    
    func decode(data: Data) -> Response? {
                
        guard let response = try? JSONDecoder().decode(Response.self, from: data) else {
            return nil
        }
        return response
    }
}
