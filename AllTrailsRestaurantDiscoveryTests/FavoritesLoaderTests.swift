//
//  FavoritesLoaderTests.swift
//  AllTrailsRestaurantDiscoveryTests
//
//  Created by Marisa Feyen on 2/10/21.
//

import XCTest
@testable import AllTrailsRestaurantDiscovery

class FavoritesLoaderTests: XCTestCase {

    var favoritesLoader: FavoritesLoader!
    override func setUpWithError() throws {
        favoritesLoader = FavoritesLoader(plistName: "test.plist")
    }

    override func tearDownWithError() throws {
        favoritesLoader = nil
    }
    
    func testFavoritesLoaderWrite() {
        let favorites = Favorites(places: ["abc", "def", "hij"])
        
        writeToPlist(favorites: favorites)
        
        guard let data = try? Data.init(contentsOf: favoritesLoader.plistURL) else {
            XCTFail()
            return
        }
        
        XCTAssertNotNil(data)
    }
    
    func testFavoritesLoaderWriteIsValid() {
        let favorites = Favorites(places: ["abc", "def", "hij"])
        
        writeToPlist(favorites: favorites)
        
        let loadedFavorites = favoritesLoader.load()
        
        XCTAssertTrue(loadedFavorites.places.count == 3)
        XCTAssertTrue(loadedFavorites.places == ["abc", "def", "hij"])
    }
    
    func writeToPlist(favorites: Favorites) {
        favoritesLoader.write(favorites: favorites)

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
