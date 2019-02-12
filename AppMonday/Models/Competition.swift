//
//  Competition.swift
//  AppMonday
//
//  Created by Nathan FALLET on 12/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class Competition: Codable {
    
    var id: Int?
    var name: String?
    var description: String?
    var criterias: String?
    var start: String?
    var end: String?
    var coming: Bool?
    var playing: Bool?
    
    func process() {
        start = start != nil ? start?.parseDate() : ""
        end = end != nil ? end?.parseDate() : ""
    }
    
}
