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
                    //use self to indicate to the closure that the method is found within this class
                    self.parseJSON(weatherData: safeData)
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
     */
    func parseJSON(weatherData: Data) {
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
            
            //Now we can simply call the conditionName as a property on the object created above
            print(weather.temperatureString)
        } catch {
            print(error)
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
//weatehr model is made an optional to cater for if something goes wrong and it returns nil
