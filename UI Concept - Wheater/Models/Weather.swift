//
//  Wheater.swift
//  UI Concept - Wheater
//
//  Created by Suprianto Djamalu on 20/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    
    let id: Int
    let condition: Condition
    let description: String
    let icon: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case condition = "main"
        case description
        case icon
    }
    
}

enum Condition: String, Codable {
    
    case clear = "Clear"
    case clouds = "Clouds"
    case snow = "Snow"
    case rain = "Rain"
    case drizzle = "Drizzle"
    case thunderstorm = "Thunderstorm"
    
}
