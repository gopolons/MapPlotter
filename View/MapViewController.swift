//
//  MapViewController.swift
//  MapPlotter
//
//  Created by Georgy Polonskiy on 07/03/2023.
//

import UIKit
import Combine
import GoogleMaps
import GoogleMapsUtils

class MapViewController: UIViewController {
    private var mapView: GMSMapView!
    private var renderer: GMUGeometryRenderer!
    private var geoJsonParser: GMUGeoJSONParser!
    
    private let viewModel: MapViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    private var loadingView: UIView = {
        let view = UIView()
        
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.startAnimating()
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.8

        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        blurEffectView.frame = view.bounds
        view.insertSubview(blurEffectView, at: 0)

        indicator.center = CGPoint(
            x: view.bounds.midX,
            y: view.bounds.midY
        )
        view.addSubview(indicator)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMapView()
        self.setupLoading()
    }

    init() {
        self.viewModel = MapViewModel()
        super.init(nibName: nil, bundle: nil)
        self.setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapViewController {
    // method for setting up notification
    // observers from view model
    private func setupData() {
        viewModel.$data
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { _ in
            } receiveValue: { data in
                self.loadingView.removeFromSuperview()
                
                // parse the data received from the server
                self.geoJsonParser = GMUGeoJSONParser(data: data)
                self.geoJsonParser.parse()
                
                // resets the renderer view upon receiving data (if renderer exists)
                // to avoid data being duplicated on the map
                if let eng = self.renderer {
                    eng.clear()
                }
                
                // render the GeoJSON from the remote repository on the map
                self.renderer = GMUGeometryRenderer(map: self.mapView, geometries: self.geoJsonParser.features)
                self.renderer.render()
            }
            .store(in: &cancellables)
    }
}

extension MapViewController {
    // method for assigning the Google Maps
    // view on the view controller
    private func setupMapView() {
        let camera = GMSCameraPosition(latitude: 51.35235237182491, longitude: -2.9246258603702318, zoom: 12)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        
        self.mapView = mapView
        self.view = mapView
    }
    
    // method for adding the loading
    // view on the view controller
    private func setupLoading() {
        self.view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: self.view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            loadingView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            loadingView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
}
