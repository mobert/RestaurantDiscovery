//
//  RestaurantViewModel.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 1/30/21.
//

import Foundation

let placeDataDidUpdateNotification = "placeDataDidUpdateNotification"

protocol DataUpdating: class {
    func updateFilterParameter(to value: String) -> Void
    func updateLocationParameters(latitude: Double, longitude: Double, radius: Double) -> Void
    func updateFavoriteState(for placeId: String, isFavorited: Bool) -> Void
}

class RestaurantViewModel {
    
    private var networkService: NetworkService
    private var favoritesLoader: FavoritesLoader
    
    private var _favorites = Favorites(places: [String]())
    var favorites: Favorites {
        get {
            queue.sync {
                return _favorites
            }
        }
    }
    
    private var _nextPageToken: String?
    var nextPageToken: String? {
        get {
            queue.sync{
                return _nextPageToken
            }
        }
    }
    
    var filter: String = "" {
        didSet {
           filterRestaurants()
        }
    }
    private var _restaurants = [Restaurant]()
    var restaurants: [Restaurant] {
        get {
            queue.sync {
                return _restaurants
            }
        }
    }
    private var _places = [Place]()
    var places: [Place] {
        get {
            queue.sync {
                return _places
            }
        }
    }
    fileprivate let DataContextKey = DispatchSpecificKey<String>()
    
    private lazy var queue: DispatchQueue = {
        let queueLabel = "com.alltrails.data-queue"
        let queue = DispatchQueue(label: queueLabel)
        queue.setSpecific(key: DataContextKey, value: queueLabel)
        return queue
    }()
    
    init(networkService: NetworkService, favoritesLoader: FavoritesLoader) {
        self.networkService = networkService
        self.favoritesLoader = favoritesLoader
        self._favorites = favoritesLoader.load()
    }
    
    func fetchNearbyPlaces(queryParameters: QueryParameters, completion: @escaping (NetworkError?) -> Void) {
        networkService.fetchNearbyPlaces(with: queryParameters) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                completion(error)
                return
            case .success(let data):
                
                if let status = data.status, status == ResponseStatus.invalidRequest.code && queryParameters.nextPageToken != nil {
                    do {
                        sleep(5)
                        // retry
                        self.fetchNextPage()
                    }
                } else {
                    self.handleResponse(response: data)
                }
                
                completion(nil)
                return
            }
        }
    }
    
    private func handleResponse(response: Response) {
        
        guard let places = response.results else {
            return
        }
        
        if queue.runningOnThisQueue(contextStringKey: DataContextKey) {
            updateDatasource(places: places)
            self._nextPageToken = response.nextPageToken
        } else {
            queue.async {
                self.updateDatasource(places: places)
                self._nextPageToken = response.nextPageToken
            }
        }
    }
    
    func fetchNextPage() {
        if let nextPageToken = self.nextPageToken {
            let queryParameters = QueryParameters(location: nil, nextPageToken: nextPageToken)
            self.fetchNearbyPlaces(queryParameters: queryParameters) { _ in }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: placeDataDidUpdateNotification), object: nil, userInfo: nil)
        }
    }
    
    private func updateDatasource(places: [Place]) {
        
        let block: ([Place]) -> Void = { places in
            self._places += places
            self.updateRestaurants(with: places)
        }
        if queue.runningOnThisQueue(contextStringKey: DataContextKey) {
            block(places)
        } else {
            queue.async {
                block(places)
            }
        }
    }
    
    private func updateRestaurants(with places: [Place]) {
    
        let block: ([Place]) -> Void = { places in
            for place in places {
        
                let restaurant = Restaurant(placeId: place.placeId, latitude: place.geometry?.location?.lat, longitude: place.geometry?.location?.lng, name: place.name, imageRef: place.photos?[0].photoReference, numberOfReviews: place.userRatingsTotal, rating: place.rating, priceLevel: place.priceLevel, openNow: place.openingHours?.openNow)
                if let placeId = restaurant.placeId, self._favorites.places.contains(placeId) {
                    restaurant.isFavorite = true
                }
                self._restaurants.append(restaurant)
            }
        }
        
        if queue.runningOnThisQueue(contextStringKey: DataContextKey) {
            block(places)
        } else {
            queue.async {
                block(places)
            }
        }
    }
    
    private func filterRestaurants() {
        
        let block = {
            if self.filter.isEmpty {
                self._restaurants.removeAll()
                self.updateRestaurants(with: self._places)
            } else {
                self._restaurants.removeAll()
                var filteredPlaces = [Place]()
                for place in self._places {
                    if let name = place.name, name.contains(self.filter) {
                        filteredPlaces.append(place)
                    }
                }
                self.updateRestaurants(with: filteredPlaces)
            }
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: placeDataDidUpdateNotification), object: nil, userInfo: nil)
        }
        
        if queue.runningOnThisQueue(contextStringKey: DataContextKey) {
            block()
        } else {
            queue.async(execute: block)
        }
        
    }
}

extension RestaurantViewModel: DataUpdating {

    func updateFavoriteState(for placeId: String, isFavorited: Bool) {
        let block: (String, Bool) -> Void = { placeId,isFavorited in
            
            // update plist
            if isFavorited {
                self._favorites.places.append(placeId)
            } else {
                self._favorites.places = self._favorites.places.filter {($0 != placeId )}
            }
            self.favoritesLoader.write(favorites: self._favorites)
            
            for restaurant in self._restaurants {
                if restaurant.placeId == placeId {
                    restaurant.isFavorite = isFavorited
                }
            }
        }
        
        if queue.runningOnThisQueue(contextStringKey: DataContextKey) {
            block(placeId, isFavorited)
        } else {
            queue.async {
                block(placeId, isFavorited)
            }
        }
    }
    

    func updateFilterParameter(to value: String) {
        filter = value
    }
    
    func updateLocationParameters(latitude: Double, longitude: Double, radius: Double) {
        // to do: update restaurants based on map location updates
    }
}


