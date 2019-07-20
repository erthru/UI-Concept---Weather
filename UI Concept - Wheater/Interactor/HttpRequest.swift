//
//  Api.swift
//  UI Concept - Wheater
//
//  Created by Suprianto Djamalu on 20/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation

class HttpRequest<T: Decodable> {
    
    var url: URL!
    
    init(url: String) {
        self.url = URL(string: url)
    }
    
    func get(_ completion: @escaping (T?, Bool) -> ()){
        URLSession.shared.dataTask(with: url) { data, res, err in
            do {
                let obj = try JSONDecoder().decode(T.self, from: data!)
                DispatchQueue.main.async {
                    completion(obj, false)
                }
            }catch let err {
                print(err)
                DispatchQueue.main.async {
                    completion(nil, true)
                }
            }
        }.resume()
    }
    
}
