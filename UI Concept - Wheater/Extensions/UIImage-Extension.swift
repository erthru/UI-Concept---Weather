//
//  UIImage-Extension.swift
//  UI Concept - Wheater
//
//  Created by Suprianto Djamalu on 20/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    convenience init(weather: WeatherImage) {
        self.init(named: weather.rawValue)!
    }
    
}

enum WeatherImage: String {
    case clear = "img_clear"
    case rain = "img_rain"
    case storm = "img_storm"
    case cloud = "img_cloud"
    case snow = "img_snow"
    case drizzle = "img_drizzle"
}
