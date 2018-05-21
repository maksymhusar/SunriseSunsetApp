//
//  Date+Extension.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import Foundation

enum DateFormat: String {
    case fullDate = "yyyy-MM-dd'T'HH:mm:sssZ"
    case dateWithoutTime = "yyyy-MM-dd"
    case timeOnly = "HH:mm"
}

extension Date {
    func toString(format: DateFormat = .dateWithoutTime, timeZone: TimeZone = TimeZone.current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
}
