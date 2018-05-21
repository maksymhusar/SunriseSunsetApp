//
//  NetworkService.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkService {
    private static var defaultBaseURL: String {
        return "https://api.sunrise-sunset.org"
    }
    
    private let baseURL: String

    init(baseURL: String = defaultBaseURL) {
        self.baseURL = baseURL
    }
    
    /// completionHandler performed NOT in the main thread
    func request(endpoint: Endpoint, completionHandler: ((Result<Any>) -> Void)? = nil) {
        guard Reachability.isInternetAvailable else {
            completionHandler?(Result.failure(ResponseError.internetNotAvailable))
            return
        }
        
        Alamofire.request(baseURL + endpoint.path,
                          method: endpoint.method,
                          parameters: endpoint.parameters).responseJSON(queue: DispatchQueue.global()) { networkResponse in
                            completionHandler?(networkResponse.result)
        }
    }
}
