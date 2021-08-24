//
//  WeatherModel.swift
//  Clima
//
//  Created by Tyrone Oggen on 2021/07/19.
//  Copyright © 2021 Roney Writes Code. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let temperature: Double
    let cityName: String
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    /*
     this is where we handle the logic behind the condition name in what is called a computed property
     the computed property which will be returned based on the id above
    */
    var conditionName: String {
        switch conditionID {
        case 200...232 :
            return "cloud.bolt"
        case 300...321 :
            return "cloud.drizzle"
        case 500...531 :
            return "cloud.rain"
        case 600...622 :
            return "cloud.snow"
        case 700...781 :
            return "cloud.fog"
        case 800 :
            return "sun.max"
        case 801...804 :
            return "smoke"
        default:
            return "sun.max"
        }
    }
}
