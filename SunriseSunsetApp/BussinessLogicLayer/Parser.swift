//
//  Parser.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Parser {
    static func parseResponse(_ result: Result<Any>) -> Result<[String: JSON]> {
        guard result.isSuccess, let value = result.value else {
            return Result.failure(result.error ?? ResponseError.dataMissed)
        }
        
        guard let dictionary = JSON(value).dictionary,
              let status = dictionary["status"]?.string else {
                return Result.failure(ResponseError.dataMissed)
        }
        
        guard status == "OK" else {
            return Result.failure(ResponseError.failed(code: -1, description: "Some error"))
        }
        
        return Result.success(dictionary)
    }

    static func parseDayInfo(_ result: Result<Any>) -> Result<DayInfo> {
        let parsedResult = self.parseResponse(result)
        guard let value = parsedResult.value else {
            let error = parsedResult.error ?? ResponseError.dataMissed
            return Result.failure(error)
        }
        guard let dayInfoJSON = value["results"] else {
            return Result.failure(ResponseError.dataMissed)
        }
        guard let parsedItem = DayInfo(json: dayInfoJSON) else {
            return Result.failure(ResponseError.invalidFormat(for: DayInfo.self))
        }
        return Result.success(parsedItem)
    }}
