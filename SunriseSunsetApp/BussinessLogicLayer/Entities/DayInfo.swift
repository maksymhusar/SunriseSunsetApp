//
//  DayInfo.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DayInfo {
    let sunrise: Date
    let sunset: Date
}

extension DayInfo {
    init?(json: JSON) {
        guard let sunrise = json["sunrise"].stringValue.toDate(format: .fullDate),
            let sunset = json["sunset"].stringValue.toDate(format: .fullDate) else {
                return nil
        }
        self.sunrise = sunrise
        self.sunset = sunset
    }
}
