//
//  SpecificCityDayInfoViewController.swift
//  SunriseSunsetApp
//
//  Created by Maksym Husar on 5/21/18.
//  Copyright © 2018 Maksym Husar. All rights reserved.
//

import UIKit
import GooglePlaces
import DateTimePicker
import TimeZoneLocate

class SpecificCityDayInfoViewController: UIViewController, Alertable {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var changeDateButton: UIButton!
    @IBOutlet private weak var dayInfoView: DayInfoView!
    @IBOutlet private weak var selectCityButton: UIButton!
    @IBOutlet private weak var selectedCityTimezoneSwitch: UISwitch!
    
    private var selectedDate = Date() {
        didSet {
            resetTimeLabels()
            loadInfoByDateAndPlace()
        }
    }
    private var selectedPlace: GMSPlace? {
        didSet { loadInfoByDateAndPlace() }
    }
    private var currentInfo: DayInfo? {
        didSet { setupTimeLabels() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectCityButton.layer.cornerRadius = selectCityButton.bounds.height / 2.0
        changeDateButton.layer.cornerRadius = changeDateButton.bounds.height / 2.0
        changeDateButton.isHidden = true
        activityIndicator.stopAnimating()
        dayInfoView.update(sunriseTime: "Unknown", sunsetTime: "Unknown")
        loadInfoByDateAndPlace()
    }
    
    // MARK: - Private methods
    private func loadInfoByDateAndPlace() {
        currentInfo = nil
        let cityButtonTitle = selectedPlace?.name ?? "Select City"
        selectCityButton.setTitle(cityButtonTitle, for: .normal)
        dateLabel.text = selectedDate.toString()
        changeDateButton.isHidden = true
        if let selectedPlace = selectedPlace {
            activityIndicator.startAnimating()
            DataManager.instance.dayInfo(by: selectedPlace.coordinate, date: selectedDate) { [weak self] loadedInfo, error in
                self?.activityIndicator.stopAnimating()
                self?.changeDateButton.isHidden = false
                self?.currentInfo = loadedInfo
                if let error = error {
                    self?.showMessage(title: "Error", message: error.localizedDescription)
                }
            }
        } else {
            showCitySelectionScreen()
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
    
    private func showCitySelectionScreen() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction private func selectedCityTimezoneValueChanged(_ sender: UISwitch) {
        setupTimeLabels()
    }
    
    @IBAction private func selectCityPressed(_ sender: Any) {
        showCitySelectionScreen()
    }
    
    private func setupTimeLabels() {
        guard let coordinate = selectedPlace?.coordinate else { return }
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let timeZone = selectedCityTimezoneSwitch.isOn ? location.timeZone : TimeZone.current
        let sunriseTitle = currentInfo?.sunrise.toString(format: .timeOnly, timeZone: timeZone) ?? ""
        let sunsetTitle = currentInfo?.sunset.toString(format: .timeOnly, timeZone: timeZone) ?? ""
        dayInfoView.update(sunriseTime: sunriseTitle, sunsetTime: sunsetTitle)
    }
    
    private func resetTimeLabels() {
        dayInfoView.update(sunriseTime: "", sunsetTime: "")
    }
}

extension SpecificCityDayInfoViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        selectedPlace = place
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        debugPrint("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
