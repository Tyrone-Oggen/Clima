//
//  WeatherManager.swift
//  Clima
//
//  Created by Tyrone Oggen on 2021/07/09.
//  Copyright © 2021 Roney Writes Code. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2d68ff0c565a2bb111f698e0cd4991de&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        print(urlString)
        //1. Create URL
        if let url = URL(string: urlString) {
            
            //2. Create URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the URLSession a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            
            //4. Perform the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        
        do {
            //allocate it to the decoded data constat and
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) //.self is used to turn WeatherData struct to a data type
            print(decodedData.name)
        } catch {
            print(error)
        }
    }
}
