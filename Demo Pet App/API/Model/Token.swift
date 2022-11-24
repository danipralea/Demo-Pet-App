//
//  Token.swift
//  Demo Pet App
//
//  Created by Danut Pralea on 22.11.2022.
//

import Foundation

struct Token: Codable {
    let token_type: String
    let expires_in: Int
    let access_token: String
}
