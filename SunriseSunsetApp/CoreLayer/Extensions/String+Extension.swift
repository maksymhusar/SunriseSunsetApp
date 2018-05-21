//
//  String+Extension.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import Foundation

extension String {
    func toDate(format: DateFormat = .dateWithoutTime) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
}
