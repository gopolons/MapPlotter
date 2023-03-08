//
//  DataRepository.swift
//  MapPlotter
//
//  Created by Georgy Polonskiy on 07/03/2023.
//

import Foundation
import Combine
import UIKit

class DataRepository {
    private var cancellables = Set<AnyCancellable>()
    
    func getData() -> AnyPublisher<Data, Error> {
        guard let url = URL(string: MapDataAPIEndpoint.main.url()) else {
            fatalError()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
