//
//  DataManager.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import Foundation
import CoreLocation

final class DataManager {
    static let instance = DataManager()
    private init() { }
    
    func dayInfo(by coordinate: CLLocationCoordinate2D, date: Date, completionHandler: @escaping (DayInfo?) -> Void) {
        let endpoint = SunriseSunsetEndpoint.info(latitude: coordinate.latitude, longitude: coordinate.longitude, date: date)
        NetworkService().request(endpoint: endpoint) { networkResponse in
            let parsedResponse = Parser.parseDayInfo(networkResponse)
            DispatchQueue.main.async {
                completionHandler(parsedResponse.value)
            }
        }
    }
}
