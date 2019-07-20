//
//  WheaterResponse.swift
//  UI Concept - Wheater
//
//  Created by Suprianto Djamalu on 20/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
    
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let wind: Wind
    let sys: Sys
    let name: String
    
}

struct Coord: Decodable {
    
    let lon: Double
    let lat: Double
    
}


struct Main: Decodable {
    
    let temp: Double
    let pressure: Double
    let humidity: Double
    let tempMin: Double
    let tempMax: Double
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case pressure
        case humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
}

struct Sys: Decodable {
    
    let sunrise: Double
    let sunset: Double
    
}

struct Wind: Decodable {
    
    let speed: Double
    let deg: Double
    
}
