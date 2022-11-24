//
//  Pagination.swift
//  Demo Pet App
//
//  Created by Danut Pralea on 22.11.2022.
//

import Foundation

struct Pagination: Codable {
    let count_per_page: Int
    let total_count: Int
    let current_page: Int
    let total_pages: Int
}
