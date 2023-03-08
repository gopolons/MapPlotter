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
    
    private func fetchFromDataRepository() {
        // fetches data from remote repository
        dataRepo.getData()
            .sink { completion in
                switch completion {
                case .finished:
                    // handle completed receiving data
                    return
                case .failure(_):
                    // handle encountered failure
                    return
                }
            } receiveValue: { data in
                self.data = data
            }
            .store(in: &cancellables)
    }
    
    private func setupNotifications() {
        // receives a notification when app state changes
        // & requests data from the remote data repository
        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification, object: nil)
            .sink { _ in
                self.fetchFromDataRepository()
            }
            .store(in: &cancellables)
    }
    
    init() {
        // initiates and assigns the data repository
        self.dataRepo = DataRepository()
        
        // subscribes for state change notifications
        // for fetching data
        self.setupNotifications()
    }
}
