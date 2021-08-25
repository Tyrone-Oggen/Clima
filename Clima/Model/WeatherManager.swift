//
//  WeatherManager.swift
//  Clima
//
//  Created by Tyrone Oggen on 2021/07/09.
//  Copyright © 2021 Roney Writes Code. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2d68ff0c565a2bb111f698e0cd4991de&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        /*
         1. Create URL from string using an if let becasuse the URL() returns an optional string and won't work if the url is incorrect
        */
        if let url = URL(string: urlString) {
            
            /*
             2. Create URLSession
             This is essentiallly the part where the browser session is emulated in swift*/
            let session = URLSession(configuration: .default)
            
            /*
             3. Give the URLSession created above a dataTask, using the method that retrieves the content of the url and calls a handler upon completion.
             Because the dataTask method returns a URLSessionDataTask, we can set the output as a contant called task
             
             The completionHandler param is changed to be a trailing closure
             */
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return //to exit out the function if there was an errror
                }
                
                if let safeData = data {
                    /*
                        use self to indicate to the closure that the method is found within this class
                        if let used because the return type of the parseJSON method is optional
                     */
                    if let weather = self.parseJSON(weatherData: safeData) {
                        //This is done to be able to send it to whichever view controller wants to make use of the weather data and they can do so by assiigning themselves as the delegate and using thr protocol as a data type
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            
            
            /*4. Perform the task created above
             The term resume is used because they all start at a suspended state
             */
            task.resume()
        }
    }
    
    /*
     The fucntion created to perform the parsing of the data received which will be performed on the data format returned from the dataTask
     This will be where we take the JSON received from the API and convert it to a swift object that we will map to our Weather model
     
     In order to parse the data from a JSON format, we need to inform the compiler how the data is structured by making use of the weatherData struct
     
     The parseJSOn method is made to return the weatherModel object we made so that wherever it is called can be stored and used
     Weatehr model return type is made an optional to cater for if something goes wrong and it returns nil
     */
    func parseJSON(weatherData: Data) -> WeatherModel? {
        //create a decoder to decode the object received
        let decoder = JSONDecoder()
        
        //The do handles the section that implements the try section of the decode
        do {
            /*
                The decoder.decode method expects a type using the model we just created as well as the data it's going to be decoding
                Try is inserted to cater for the throw that the .decode method is marked with
                Because decode has an output and will create an WeatherData object, it's stored in a constant
             */
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) //.self is used to turn WeatherData struct to a data type
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            //Allocate the data we fetched from the API and store it within our WeatherModel that handles all weather data
            let weather = WeatherModel(conditionID: id, temperature: temp, cityName: name)
            return weather
        } catch {
            print(error)
            return nil
        }
    }
}



// MARK:- The previous handle method befor the completion handler was converted to a trailing enclosure
/*
//The fucntion created to perform the handling of the data once it has been retrieved from the internet
func handle(data: Data?, response: URLResponse?, error: Error?) {
    if error != nil {
        print(error!)
        return //to exit out the function if there was an errror
    }
    
    if let safeData = data {
        let dataString = String(data: safeData, encoding: .utf8)
        print(dataString)
    }
}
*/
