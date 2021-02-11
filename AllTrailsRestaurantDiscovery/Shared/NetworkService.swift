//
//  NetworkService.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 2/2/21.
//

import Foundation

enum QueryItemType {
    case location, radius, type, nextPageToken, apiKey
    
    var name: String {
        switch self {
        case .location:
            return "location"
        case .radius:
            return "radius"
        case .type:
            return "type"
        case .nextPageToken:
            return "pagetoken"
        case .apiKey:
            return "key"
        }
    }
}

enum SearchComponent {
    case place, photo
    
    var string: String {
        switch self {
        case .place:
            return "//maps.googleapis.com/maps/api/place/nearbysearch/json"
        case .photo:
            return "https://maps.googleapis.com/maps/api/place/photo"
        }
    }
}

enum NetworkError: Error {
    case searchTerm, badURL, urlError, decodingError
}

enum ResponseStatus {
    case ok, zeroResults, overQueryLimit, requestDenied, invalidRequest, unknown
    
    var code: String {
        switch self {
        case .ok:
            return "OK"
        case .zeroResults:
            return "ZERO_RESULTS"
        case .overQueryLimit:
            return "OVER_QUERY_LIMIT"
        case .requestDenied:
            return "REQUEST_DENIED"
        case .invalidRequest:
            return "INVALID_REQUEST"
        case .unknown:
            return "UNKNOWN_ERROR"
        }
    }
}

class NetworkService {
        
    static let shared = NetworkService()
    private let session = URLSession.shared
    let placeDecoder = PlaceDecoder()
    
    var placeComponentString = SearchComponent.place.string
    var photoComponentString = SearchComponent.photo.string
     
    func fetchNearbyPlaces(with queryParameters: QueryParameters, completion: @escaping (Result<Response, NetworkError>) -> Void) {
        
        guard let queryItems = getNearbyPlacesQueryItems(queryParameters: queryParameters) else {
            completion(.failure(.searchTerm))
            return
        }
        
        guard let url = getNearbySearchURL(queryItems: queryItems) else {
            completion(.failure(.badURL))
            return
        }
            
        fetchDataFromURL(url: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                guard let response = self.placeDecoder.decode(data: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(response))
            }
        }
    }
    
    private func getNearbySearchURL(queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents(string: placeComponentString)
        components?.scheme = "https"
        components?.queryItems = queryItems
                
        guard let url = components?.url else {
            return nil
        }
        
        return url
    }
    
    private func getNearbyPlacesQueryItems(queryParameters: QueryParameters) -> [URLQueryItem]? {
        var queryItems = [URLQueryItem]()
        if let location = queryParameters.location {
            let latitude = location.latitude
            let longitude = location.longitude
            let radius = location.radius
            let locationQueryString = latitude + "," + longitude
            queryItems.append(URLQueryItem(name: QueryItemType.location.name, value: locationQueryString))
            queryItems.append(URLQueryItem(name: QueryItemType.radius.name, value: radius))
            queryItems.append(URLQueryItem(name: QueryItemType.type.name, value: "restaurant"))
        } else if let nextPageToken = queryParameters.nextPageToken {
            queryItems.append(URLQueryItem(name: QueryItemType.nextPageToken.name, value: nextPageToken))
        } else {
            return nil
        }
        queryItems.append(URLQueryItem(name: QueryItemType.apiKey.name, value: apiKey))
        
        return queryItems
    }
    
    func getPhotoURL(photoReference: String) -> URL? {

        var components = URLComponents(string: photoComponentString)
        components?.scheme = "https"
        let maxWidth = "400"
        let maxWidthQueryItem = URLQueryItem(name: "maxwidth", value: maxWidth)
        let referenceQueryItem = URLQueryItem(name: "photoreference", value: photoReference)
        let keyQueryItem = URLQueryItem(name: "key", value: apiKey)
        components?.queryItems = [maxWidthQueryItem, referenceQueryItem, keyQueryItem]
                
        guard let url = components?.url else {
            return nil
        }
        
        return url
    }
    
    private func fetchDataFromURL(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {(data, response, error) in
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.urlError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.urlError))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}

