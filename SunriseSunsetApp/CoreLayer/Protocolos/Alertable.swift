//
//  Alertable.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import UIKit

protocol Alertable {
    func showMessage(title: String?, message: String?, handler: (() -> Void)?)
}

extension Alertable where Self: UIViewController {
    
    func showMessage(title: String?, message: String? = nil, handler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            handler?()
        })
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
