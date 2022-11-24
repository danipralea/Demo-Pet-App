//
//  NSObject+Extra.swift
//  Demo Pet App
//
//  Created by Danut Pralea on 22.11.2022.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var ClassName: String {
        return String(describing: self)
    }
}
