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
    
    @discardableResult
    func getData() -> AnyPublisher<Data, Error> {
        let subject: PassthroughSubject<Data, Error> = .init()
        
        // send subject depending on the response of the network
        NetworkHandler.request(method: .get, endpoint: MapDataAPIEndpoint.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    subject.send(completion: .failure(error))
                case .finished:
                    subject.send(completion: .finished)
                }
            } receiveValue: { response in
                subject.send(response)
            }
            .store(in: &cancellables)
        
        return subject.eraseToAnyPublisher()
    }
    
    init() {
        self.getData()
    }
}
