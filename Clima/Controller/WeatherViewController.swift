//
//  ViewController.swift
//  Clima
//
//  Created by Tyrone Oggen on 2021/07/07.
//  Copyright © 2021 Roney Writes Code. All rights reserved.
//


import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self

        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}


//MARK: - UITextFieldDelegate extension
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Please enter a location"
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = (searchTextField.text?.trimmingCharacters(in: .whitespaces)) {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}


//MARK: - WeatherManagerDelegate extension
extension WeatherViewController: WeatherManagerDelegate {
    /*
     _ used to conform more to the swift best practice conventions
     identity of the of the object calling the delegate method is added to the delegate method
    */
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        //handle async code
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            
            //system name is used here for the SF Symbol images
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - CLLocationManagerDelegate extension
extension WeatherViewController: CLLocationManagerDelegate {
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*
         locations.last used to get the last value returned to ensure the most accuracy
         locations.last returns optional so we if let that guy
         */
        if let location = locations.first {
            /*
             This is to cater for the locationManager.requestLocation() being called when the app opens, this is done to make sure that the user is able to re-request the location update when the user uses the text input
             */
            locationManager.stopUpdatingLocation()
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
