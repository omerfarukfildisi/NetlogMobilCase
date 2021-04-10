//
//  AddressResult.swift
//  NetlogMobilCase
//
//  Created by Ömer Fildişi on 10.04.2021.
//

import Foundation

struct AddressResult : Decodable {
    var results : [FormattedAddress]
}

struct FormattedAddress :  Decodable {
    var formatted_address : String
}
