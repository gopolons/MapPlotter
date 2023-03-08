//
//  Errors.swift
//  MapPlotter
//
//  Created by Georgy Polonskiy on 08/03/2023.
//

import Foundation

enum NetError: Error {
    case noConnection
    case invalidURL(String)
    case unknownError(String?)
    
    func localizedDescription() -> String {
        switch self {
        case .noConnection:
            return "Could not connect to the remote server"
        case .invalidURL(let url):
            return "Could not decode the URL for the request: \(url)"
        case .unknownError(let str):
            if let str = str {
                return str
            } else {
                return "Encountered an unknown error"
            }
        }
    }
}

enum CodingError: Error {
    case decodingError
    case encodingError
    
    func localizedDescription() -> String {
        switch self {
        case .decodingError:
            return "Error decoding data"
        case .encodingError:
            return "Error encoding data"
        }
    }
}
