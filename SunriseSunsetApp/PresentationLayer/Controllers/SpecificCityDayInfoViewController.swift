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
class SpecificCityDayInfoViewController: UIViewController {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var changeDateButton: UIButton!
    @IBOutlet private weak var dayInfoView: DayInfoView!
    @IBOutlet private weak var selectCityButton: UIButton!
    
    private var selectedDate = Date() {
        didSet {
            resetTimeLabels()
            loadInfoByDateAndPlace()
        }
    }
    private var selectedPlace: GMSPlace? {
        didSet { loadInfoByDateAndPlace() }
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
        let cityButtonTitle = selectedPlace?.name ?? "Select City"
        selectCityButton.setTitle(cityButtonTitle, for: .normal)
        dateLabel.text = selectedDate.toString()
        changeDateButton.isHidden = true
        if let selectedPlace = selectedPlace {
            activityIndicator.startAnimating()
            DataManager.instance.dayInfo(by: selectedPlace.coordinate, date: selectedDate) { [weak self] loadedInfo in
                self?.activityIndicator.stopAnimating()
                self?.changeDateButton.isHidden = false
                let sunriseTitle = loadedInfo?.sunrise.toString(format: .timeOnly) ?? ""
                let sunsetTitle = loadedInfo?.sunset.toString(format: .timeOnly) ?? ""
                self?.dayInfoView.update(sunriseTime: sunriseTitle, sunsetTime: sunsetTitle)
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
    
    @IBAction func selectCityPressed(_ sender: Any) {
        showCitySelectionScreen()
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
