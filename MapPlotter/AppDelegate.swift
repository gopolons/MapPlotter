//
//  AppDelegate.swift
//  MapPlotter
//
//  Created by Georgy Polonskiy on 07/03/2023.
//

import UIKit
import GoogleMaps
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GMSAPIKey") as? String else {
            return false
        }
        
        // activate Google Maps and Firebase SDKs
        GMSServices.provideAPIKey(apiKey)
        FirebaseApp.configure()
        
        return true
    }
}

