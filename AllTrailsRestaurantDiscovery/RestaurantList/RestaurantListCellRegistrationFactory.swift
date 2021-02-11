//
//  RestaurantListCellRegistrationFactory.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 1/30/21.
//

import Foundation

struct RestaurantListCellRegistrationFactory {

    static func standardCellClassRegistrants() -> [CellClassRegistrationData] {
        return [RestaurantCollectionViewCell.classRegistrationData()]
    }
}
