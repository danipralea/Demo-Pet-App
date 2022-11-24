//
//  Animals.swift
//  Demo Pet App
//
//  Created by Danut Pralea on 22.11.2022.
//

import Foundation

struct Animals: Codable {
    let animals: [Pet]
    let pagination: Pagination
}
