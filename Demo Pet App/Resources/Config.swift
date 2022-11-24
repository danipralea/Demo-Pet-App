//
//  Config.swift
//  Demo Pet App
//
//  Created by Danut Pralea on 21.11.2022.
//

import Foundation

struct Config {
    
    static var API_KEY: String? {
        return Bundle.main.infoDictionary?["API_KEY"] as? String
    }
    
    static var API_SECRET: String? {
        return Bundle.main.infoDictionary?["API_SECRET"] as? String
    }
    
}
