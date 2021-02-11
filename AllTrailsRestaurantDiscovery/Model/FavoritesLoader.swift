//
//  PList.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 2/2/21.
//

import Foundation

struct Favorites: Codable {
    var places: [String]
}

class FavoritesLoader {
    var plistName:String
    var plistURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent(plistName)
    }
    
    init(plistName: String) {
        self.plistName = plistName
    }
    
    func load() -> Favorites {
        let decoder = PropertyListDecoder()
        
        guard let data = try? Data.init(contentsOf: plistURL),
              let favorites = try? decoder.decode(Favorites.self, from: data)
        else {
            return Favorites(places: [String]())
        }
        
        return favorites
    }
}

extension FavoritesLoader {
    func write(favorites: Favorites) {
        let encoder = PropertyListEncoder()
        
        if let data = try? encoder.encode(favorites) {
            if FileManager.default.fileExists(atPath: plistURL.path) {
                try? data.write(to: plistURL)
            } else {
                FileManager.default.createFile(atPath: plistURL.path, contents: data, attributes: nil)
            }
        }
    }
}
