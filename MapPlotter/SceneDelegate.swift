//
//  SceneDelegate.swift
//  MapPlotter
//
//  Created by Georgy Polonskiy on 07/03/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MapViewController()
        
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

