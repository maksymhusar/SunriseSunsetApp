//
//  MyDayInfoViewController.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import UIKit
import DateTimePicker

class MyDayInfoViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var sunriseTimeLabel: UILabel!
    @IBOutlet private weak var sunsetTimeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var changeDateButton: UIButton!
    
    private var selectedDate = Date() {
        didSet {
            loadInfoByDateAndLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.layer.cornerRadius = logoImageView.bounds.height / 2.0
        changeDateButton.layer.cornerRadius = changeDateButton.bounds.height / 2.0
        changeDateButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadInfoByDateAndLocation()
    }
    
    private func loadInfoByDateAndLocation() {
        setupInitialState()
        if let currentLocation = LocationManager.instance.currentLocation {
            activityIndicator.startAnimating()
            DataManager.instance.dayInfo(by: currentLocation, date: selectedDate) { [weak self] loadedInfo in
                self?.activityIndicator.stopAnimating()
                self?.changeDateButton.isHidden = false
                self?.sunsetTimeLabel.text = loadedInfo?.sunset.toString(format: .timeOnly)
                self?.sunriseTimeLabel.text = loadedInfo?.sunrise.toString(format: .timeOnly)
            }
        } else {
            activityIndicator.startAnimating()
            LocationManager.instance.requestLocation { [weak self] error in
                self?.activityIndicator.stopAnimating()
                if error == nil {
                    self?.loadInfoByDateAndLocation()
                }
            }
        }
    }
    
    @IBAction func changeDatePressed(_ sender: Any) {
        let minimumDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        let picker = DateTimePicker.show(selected: selectedDate, minimumDate: minimumDate)
        picker.dateFormat = "dd/MM/YYYY"
        picker.isDatePickerOnly = true
        picker.completionHandler = { [weak self] date in
            self?.selectedDate = date
        }
    }
    
    private func setupInitialState() {
        dateLabel.text = selectedDate.toString()
        changeDateButton.isHidden = true
        sunsetTimeLabel.text = nil
        sunriseTimeLabel.text = nil
    }
    
}
