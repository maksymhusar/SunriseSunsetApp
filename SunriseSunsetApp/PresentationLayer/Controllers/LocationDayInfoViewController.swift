//
//  LocationDayInfoViewController.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import UIKit
import DateTimePicker
import CoreLocation

class LocationDayInfoViewController: UIViewController, Alertable {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var changeDateButton: UIButton!
    @IBOutlet private weak var dayInfoView: DayInfoView!
    
    private var selectedDate = Date() {
        didSet {
            resetTimeLabels()
            loadInfoByDateAndLocation()
        }
    }
    private var currentLocation: CLLocationCoordinate2D? {
        didSet { loadInfoByDateAndLocation() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.layer.cornerRadius = logoImageView.bounds.height / 2.0
        changeDateButton.layer.cornerRadius = changeDateButton.bounds.height / 2.0
        changeDateButton.isHidden = true
        loadInfoByDateAndLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestCurrentLocation()
    }
    
    // MARK: - Private methods
    private func loadInfoByDateAndLocation() {
        dateLabel.text = selectedDate.toString()
        changeDateButton.isHidden = true
        if let currentLocation = currentLocation {
            activityIndicator.startAnimating()
            DataManager.instance.dayInfo(by: currentLocation, date: selectedDate) { [weak self] loadedInfo, error in
                self?.activityIndicator.stopAnimating()
                self?.changeDateButton.isHidden = false
                let sunriseTitle = loadedInfo?.sunrise.toString(format: .timeOnly) ?? ""
                let sunsetTitle = loadedInfo?.sunset.toString(format: .timeOnly) ?? ""
                self?.dayInfoView.update(sunriseTime: sunriseTitle, sunsetTime: sunsetTitle)
                if let error = error {
                    self?.showMessage(title: "Error", message: error.localizedDescription)
                }
            }
        } else {
            requestCurrentLocation()
        }
    }
    
    @IBAction private func changeDatePressed(_ sender: Any) {
        let minimumDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        let picker = DateTimePicker.show(selected: selectedDate, minimumDate: minimumDate)
        picker.dateFormat = "dd/MM/YYYY"
        picker.isDatePickerOnly = true
        picker.completionHandler = { [weak self] date in
            self?.selectedDate = date
        }
    }
    
    private func resetTimeLabels() {
        dayInfoView.update(sunriseTime: "", sunsetTime: "")
    }
    
    private func requestCurrentLocation() {
        activityIndicator.startAnimating()
        LocationManager.instance.requestLocation { [weak self] error in
            self?.activityIndicator.stopAnimating()
            if error == nil {
                self?.currentLocation = LocationManager.instance.currentLocation
            } else {
                self?.showMessage(title: "Error", message:"Can't get your location. Check App Settings and try again")
                self?.dayInfoView.update(sunriseTime: "Unknown", sunsetTime: "Unknown")
            }
        }
    }
}
