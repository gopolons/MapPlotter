//
//  NetworkHandler.swift
//  MapPlotter
//
//  Created by Georgy Polonskiy on 08/03/2023.
//

import Foundation
import Combine

enum HTTPMethod: String {
    typealias RawValue = String
    
    case get = "GET"
}

protocol APIEndpointProtocol {
    func url() -> String
}

final class NetworkHandler {
    static var loadObserver: NSKeyValueObservation?
    
    static func request(method: HTTPMethod, endpoint: APIEndpointProtocol) -> Future<Data, Error> {
        return Future { promise in
            guard let url = URL(string: endpoint.url()) else {
                promise(.failure(NetError.invalidURL(endpoint.url())))
                return
            }
            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.httpMethod = method.rawValue
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    promise(.failure(error!))
                    return
                }
                promise(.success(data))
            }
            
            task.resume()
        }
    }
}
