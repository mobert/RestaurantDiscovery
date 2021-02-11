//
//  CollectionViewManager.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 1/30/21.
//

import UIKit

class CollectionViewManager: NSObject, UIScrollViewDelegate {
    
    weak var controller: AnyObject?
    
    init(controller: AnyObject?) {
        self.controller = controller
        super.init()
    }
    
    // MARK: - Cell Registration
    func registerCellClasses(_ collectionView: UICollectionView, classes: [CellClassRegistrationData]) {
        for data in classes {
            collectionView.register(data.cellClass, forCellWithReuseIdentifier: data.reuseIdentifier)
        }
    }
}

