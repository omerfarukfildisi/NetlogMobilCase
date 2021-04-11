//
//  GoogleService.swift
//  NetlogMobilCase
//
//  Created by Ömer Fildişi on 10.04.2021.
//

import Foundation

class GoogleService {

func getAddress(lat:Double, lng:Double, completion: @escaping (AddressResult?) -> ()){
    
    let request = NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lng)&key=AIzaSyAGtN7co7XyS0EK0ZAxtR_yYzaCQqW_qU0")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
        if let error = error {
            print(error.localizedDescription)
            completion(nil)
        } else if let data = data {
            let addressResult = try? JSONDecoder().decode(AddressResult.self, from: data)
            completion(addressResult)
            }
        
    }.resume()
}
}
