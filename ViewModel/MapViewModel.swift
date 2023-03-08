//
//  MapViewModel.swift
//  MapPlotter
//
//  Created by Georgy Polonskiy on 07/03/2023.
//

import UIKit
import Combine

class MapViewModel {
    private var dataRepo: DataRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var data: Data?
    
    private func setUpNotifications() {
        dataRepo.getData()
            .sink { completion in
                switch completion {
                case .finished:
                    // handle completed receiving data
                    return
                case .failure(let err):
                    // handle encountered failure
                    return
                }
            } receiveValue: { data in
                self.data = data
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification, object: nil)
            .sink { _ in
                self.dataRepo.getData()
            }
            .store(in: &cancellables)
    }
    
    init() {
        self.dataRepo = DataRepository()
        setUpNotifications()
    }
}
