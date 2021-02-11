//
//  AllTrailsRestaurantDiscoveryTests.swift
//  AllTrailsRestaurantDiscoveryTests
//
//  Created by Marisa Feyen on 2/10/21.
//

import XCTest
@testable import AllTrailsRestaurantDiscovery

// favorite

class ViewModelTests: XCTestCase {
    
    private var viewModel: RestaurantViewModel!
    private var favoritesLoader: FavoritesLoader!
    private var networkService: MockNetworkService!
    
    override func setUpWithError() throws {
        networkService = MockNetworkService()
        favoritesLoader = FavoritesLoader(plistName: "favoritesTest.plist")
        viewModel = RestaurantViewModel(networkService: networkService, favoritesLoader: favoritesLoader)
    }

    override func tearDownWithError() throws {
        networkService = nil
        favoritesLoader = nil
        viewModel = nil
    }
    
    // MARK: - Fetch
    
    func testFailureByQueryParameters() {

        let queryParameters = QueryParameters()
        networkService.placesResult = Result<Response, NetworkError>.failure(NetworkError.searchTerm)
        var error: NetworkError?
        viewModel.fetchNearbyPlaces(queryParameters: queryParameters) { error = $0 }
    
        guard let errorResponse = error else {
            XCTFail()
            return
        }
        XCTAssertTrue(errorResponse==NetworkError.searchTerm)

    }
    
    func testLocationQueryParameters() {
        let queryParameters = getLocationParameters()
        
        var error: NetworkError?
        viewModel.fetchNearbyPlaces(queryParameters: queryParameters) { error = $0 }
    
        XCTAssertNil(error)
        
    }
    
    func testNextPageQueryParameter() {
        let nextPageToken = "test"
        let queryParameters = QueryParameters(location: nil, nextPageToken: nextPageToken)
        
        var error: NetworkError?
        viewModel.fetchNearbyPlaces(queryParameters: queryParameters) { error = $0 }
    
        XCTAssertNil(error)
    }
    
    func testPlaceURLFailure() {
        let queryParameters = getLocationParameters()
        networkService.placeComponentString = "test"
        var error: NetworkError?
        networkService.placesResult = Result<Response, NetworkError>.failure(NetworkError.urlError)

        
        viewModel.fetchNearbyPlaces(queryParameters: queryParameters) { error = $0 }
        
        guard let errorResponse = error else {
            XCTFail()
            return
        }
        XCTAssertTrue(errorResponse==NetworkError.urlError)
    }
    
    func testParseSuccess() {
        let queryParameters = getLocationParameters()
        var error: NetworkError?
        let data = retrieveJson(fileName: "SuccessfulResult")
        networkService.networkResult = (data: data, error: nil)

        viewModel.fetchNearbyPlaces(queryParameters: queryParameters) { error = $0 }
            
        XCTAssertNil(error)
    }
    
    func testParseResultIsValid() {
        let queryParameters = getLocationParameters()
        var error: NetworkError?
        let data = retrieveJson(fileName: "SuccessfulResult")
        
        networkService.networkResult = (data: data, error: nil)
        
        viewModel.fetchNearbyPlaces(queryParameters: queryParameters) { error = $0 }
        let place = viewModel.places[0]
        
        XCTAssertNil(error)
        XCTAssertTrue(viewModel.places.count == 20)
        AssertPlacesDecode(place)
        
    }
    
    func testShouldFetchNextPage() {
        
        let queryParameters = getLocationParameters()
        let data = retrieveJson(fileName: "SuccessfulResult")
        networkService.networkResult = (data: data, error: nil)
        
        viewModel.fetchNearbyPlaces(queryParameters: queryParameters) { _ = $0 }
        
        XCTAssertNotNil(viewModel.nextPageToken)
    }
    
    func testShouldNotFetchNextPage() {
        let queryParameters = getLocationParameters()
        let data = retrieveJson(fileName: "SuccessfulJsonWithNoNextPage")
        networkService.networkResult = (data: data, error: nil)
        
        viewModel.fetchNearbyPlaces(queryParameters: queryParameters) { _ = $0 }
        
        XCTAssertNil(viewModel.nextPageToken)
    }
    
    func testAddRestaurantToFavorites() {
        let favorite = "favorite"

        updateFavorite(favorite: favorite, isFavorited: true)

        XCTAssertTrue(viewModel.favorites.places.contains(favorite))
    }
    
    func testRemoveRestaurantFromFavorites() {
        let unfavorite = "unfavorite"
        // add to favorites
        viewModel.updateFavoriteState(for: unfavorite, isFavorited: true)
        XCTAssertTrue(viewModel.favorites.places.contains(unfavorite))

        // remove from favorites
        updateFavorite(favorite: unfavorite, isFavorited: false)

        XCTAssertFalse(viewModel.favorites.places.contains(unfavorite))
    }
    
    func testFilterForString() {
        let queryParameters = getLocationParameters()
        var error: NetworkError?
        let data = retrieveJson(fileName: "SuccessfulResult")
        networkService.networkResult = (data: data, error: nil)
        viewModel.fetchNearbyPlaces(queryParameters: queryParameters) { error = $0 }
        
        viewModel.updateFilterParameter(to: "Hotel")
        
        XCTAssertNil(error)
        XCTAssertTrue(viewModel.restaurants.count == 6)
    }
    
    private func getLocationParameters() -> QueryParameters {

        let locationParameters = LocationParameters(latitude: String(30.267153), longitude: String(-97.7430608), radius: String(1000))
        let queryParameters = QueryParameters(location: locationParameters, nextPageToken: nil)
        
        return queryParameters
    }
    
    private func retrieveJson(fileName: String) -> Data? {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {
            XCTFail()
            return nil
        }
        let url = URL(fileURLWithPath: path)
        var data = Data()
        do {
            data = try Data(contentsOf: url)
        } catch {
            XCTFail()
        }
        return data
    }
    
    private func AssertPlacesDecode(_ place: Place) {
        XCTAssertTrue(place.name == "Premier Inn London Leicester Square hotel")
        XCTAssertTrue((place.photos?[0].photoReference == "ATtYBwKDD6OezPM5axOeZgbhOiAnD0yyP4YqaJePWo8VJVWtH9uNJjZIXyB82hXXmk8Hv3dQLB3Xi7IGIZ4ovE2b-vKwsJ3Tv-az6bfYP0R_EhTJf6kWJacdiTAUp56kUcIDzKyGwvcN8zQPQzRIUFAnzqIUzea86oQsTr3yeNKkUs9su6hO"))
        XCTAssertTrue(place.placeId == "ChIJJUyxFNIEdkgRajb-0tlYT_0")
        XCTAssertTrue(place.openingHours?.openNow == true)
        XCTAssertTrue(place.rating == 4.2)
        XCTAssertTrue(place.priceLevel == nil)
        XCTAssertTrue(place.userRatingsTotal == 629)
        XCTAssertTrue(place.geometry?.location?.lat == 51.5110895)
        XCTAssertTrue(place.geometry?.location?.lng == -0.1302171)
    }
    
    func updateFavorite(favorite: String, isFavorited: Bool) {
        viewModel.updateFavoriteState(for: favorite, isFavorited: isFavorited)

        addTeardownBlock {
            do {
                let path = self.favoritesLoader.plistURL.path
                try FileManager.default.removeItem(atPath: path)
            } catch {
                XCTFail()
            }
        }
    }
}
