//
//  Tip.swift
//  AppMonday
//
//  Created by Nathan FALLET on 13/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class Tip: Codable {
    
    var id: Int?
    var name: String?
    var description: String?
    var publish: String?
    
    func process() {
        publish = publish != nil ? publish?.parseDate() : ""
    }
    
}
