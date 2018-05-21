//
//  MyDayInfoViewController.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import UIKit

class MyDayInfoViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadInfoForCurrentLocation()
    }
    
    private func loadInfoForCurrentLocation() {
        if let currentLocation = LocationManager.instance.currentLocation {
            DataManager.instance.dayInfo(by: currentLocation) { loadedInfo in
                debugPrint(loadedInfo)
            }
        } else {
            LocationManager.instance.requestLocation { [weak self] error in
                if error == nil {
                    self?.loadInfoForCurrentLocation()
                }
            }
        }
    }
    
}
