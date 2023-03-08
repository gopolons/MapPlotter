//
//  Constants.swift
//  MapPlotter
//
//  Created by Georgy Polonskiy on 08/03/2023.
//

import Foundation

class NetworkConstants {
    static let baseURL: String = "https://landstack-public-dev2.s3-eu-west-2.amazonaws.com/"
}

enum MapDataAPIEndpoint: APIEndpointProtocol {
    case main
    
    func url() -> String {
        let resp = NetworkConstants.baseURL
        
        switch self {
        case .main:
            return resp + "temp/testAppData.json"
        }
    }
}
