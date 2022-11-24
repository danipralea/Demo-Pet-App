//
//  Pet.swift
//  Demo Pet App
//
//  Created by Danut Pralea on 21.11.2022.
//

import Foundation

struct Pet: Codable {
    var id: Int?
    var organization_id: String?
    var url: String?
    var type: String?
    var species: String?
    var breeds: Breed?
    var name: String?
    var size: String?
    var gender: String?
    var contact: Contact?
}

struct Breed: Codable {
    var primary: String?
    var secondary: String?
    var mixed: Bool?
    var unknown: Bool?
}

struct Contact: Codable {
    var email: String?
    var phone: String?
    var address: Address?
}

struct Address: Codable {
    var address1: String?
    var address2: String?
    var city: String?
    var state: String?
    var postcode: String?
    var country: String?
}

extension Address {
    var fullAddress: String {
        let ad1 = address1 ?? ""
        let ad2 = address2 ?? ""
        let c = city ?? ""
        let s = state ?? ""
        let p = postcode ?? ""
        let cntry = country ?? ""
        return "\(ad1) \(ad2) \(c) \(s) \(p) \(cntry)"
    }
}
