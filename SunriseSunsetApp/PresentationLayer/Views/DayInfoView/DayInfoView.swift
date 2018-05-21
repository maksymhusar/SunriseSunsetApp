//
//  DayInfoView.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import UIKit

class DayInfoView: UIView {
    @IBOutlet private weak var sunriseTimeLabel: UILabel!
    @IBOutlet private weak var sunsetTimeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
        configure()
    }
    
    func update(sunriseTime: String, sunsetTime: String) {
        sunriseTimeLabel.text = sunriseTime
        sunsetTimeLabel.text = sunsetTime
    }
    
    // MARK: - Private methods
    private func configure() { }
}
