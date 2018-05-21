//
//  ResponseError.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import Foundation

enum ResponseError: LocalizedError {
    case internetNotAvailable
    case dataMissed
    case invalidFormat(for: Any.Type)
    case failed(code: Int, description: String?)
    
    var errorDescription: String? {
        switch self {
        case .internetNotAvailable:
            return "Internet not available"
        case .dataMissed:
            return "Error: Data missed"
        case .invalidFormat(for: let entityType):
            return "Error: Wrong format for \(entityType)"
        case .failed(_, let description):
            return description
        }
    }
}
