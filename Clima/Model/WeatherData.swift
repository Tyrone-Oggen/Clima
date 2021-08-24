//
//  WeatherData.swift
//  Clima
//
//  Created by Tyrone Oggen on 2021/07/19.
//  Copyright © 2021 Roney Writes Code. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    //To get the name item from the API response
    let name: String
    let main: Main
    let weather: [Weather]
}

//This main struct is created to be a representation of the object within an object in the API response that we can then map to the decoder
struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
