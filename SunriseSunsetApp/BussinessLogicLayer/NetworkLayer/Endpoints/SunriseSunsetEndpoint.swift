//
//  SunriseSunsetEndpoint.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import Foundation
import Alamofire

enum SunriseSunsetEndpoint {
    case info(latitude: Double, longitude: Double, date: Date?)
}

// MARK: Endpoint implementation
extension SunriseSunsetEndpoint: Endpoint {
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .info:
            return "/json"
        }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .info(let latitude, let longitude, let date):
            params = ["lat": latitude, "lng": longitude]
            if let date = date {
                params?["date"] = date.toString()
            }
        }
        return params
    }
}
