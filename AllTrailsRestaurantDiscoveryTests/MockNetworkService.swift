//
//  MockNetworkService.swift
//  AllTrailsRestaurantDiscoveryTests
//
//  Created by Marisa Feyen on 2/10/21.
//

import Foundation
@testable import AllTrailsRestaurantDiscovery

public typealias NetworkResult = (data: Data?, error: Error?)


class MockNetworkService: NetworkService {
    var networkResult: NetworkResult?
    var placesResult: Result<Response, NetworkError>?
    
    override func fetchNearbyPlaces(with queryParameters: QueryParameters, completion: @escaping (Result<Response, NetworkError>) -> Void) {
        
        if networkResult != nil {
            let placeResult = parse(data: networkResult!.data, error: networkResult!.error)
            completion(placeResult)
        } else if placesResult != nil {
            completion(placesResult!)
        }
    }
    
    private func parse(data: Data?, error: Error?) -> Result<Response, NetworkError> {
        if let data = data {
            if let parseResult = self.placeDecoder.decode(data: data) {
                return .success(parseResult)
            } else {
                return .failure(.decodingError)
            }
        } else if let _ = error {
            return .failure(.urlError)
        }
        return .failure(.decodingError)
    }

}
