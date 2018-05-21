//
//  LocationManager.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let instance = LocationManager()
    
    var currentLocation: CLLocationCoordinate2D? {
        return locationManager.location?.coordinate
    }
    
    private let locationManager: CLLocationManager
    private var requestLocationHandler: ((Error?) -> Void)?
    
    private override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        super.init()
        
        locationManager.delegate = self
    }
    
    func requestLocation(completionHandler: ((Error?) -> Void)? = nil) {
        requestLocationHandler = completionHandler
        locationManager.requestLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        requestLocationHandler?(nil)
        requestLocationHandler = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        requestLocationHandler?(error)
        requestLocationHandler = nil
    }
    
}
