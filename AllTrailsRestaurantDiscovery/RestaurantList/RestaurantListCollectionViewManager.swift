//
//  RestaurantListCollectionViewManager.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 1/30/21.
//

protocol Favoriting {
    func didFavorite(index: Int, isFavorite: Bool) -> Void
}

import UIKit

final class RestaurantListCollectionViewManager: CollectionViewManager, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var dataSource: RestaurantViewModel
    
    init(dataSource: RestaurantViewModel, controller: UIViewController) {
        self.dataSource = dataSource
        super.init(controller: controller)
    }
    
    // MARK: - DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionViewCell.cellID(), for: indexPath) as? RestaurantCollectionViewCell else {
            return UICollectionViewCell()
        }
        let restaurant = dataSource.restaurants[indexPath.row]
        cell.configure(restaurant: restaurant)
        return cell
    }
    
    // MARK: - Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 24.0, left: 0, bottom: 0, right: 0)
    }
}

extension RestaurantListCollectionViewManager: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if dataSource.places.count - 1 <= indexPath.item {
                dataSource.fetchNextPage()
            }
        }
    }
}

extension RestaurantListCollectionViewManager: Favoriting {
    func didFavorite(index: Int, isFavorite: Bool) {
        let restaurant = dataSource.restaurants[index]
        guard let placeId = restaurant.placeId else { return }
        dataSource.updateFavoriteState(for: placeId, isFavorited: isFavorite)
    }
    
    
}

