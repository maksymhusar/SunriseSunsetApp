//
//  GlobalAppearance.swift
//  Swift-Useful-Files
//
//  Created by Husar Maksym on 3/17/17.
//  Copyright © 2017 Husar Maksym. All rights reserved.
//

import UIKit

struct GlobalAppearance {
    
    static func configure() {
        UIButton.appearance().isExclusiveTouch = true
        
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.black
    }
}
