//
//  App.swift
//  AppMonday
//
//  Created by Nathan FALLET on 18/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import Foundation

class Project: Codable {
    
    var id: Int?
    var name: String?
    var description: String?
    var user: String?
    var link: String?
    var publish: String?
    var logo: String?
    
    func process() {
        user = user != nil ? user!.hasPrefix("@") ? String(user!.dropFirst()) : user : ""
        publish = publish != nil ? publish?.parseDate() : ""
        logo = logo == nil || logo!.isEmpty ? "NoLogo" : logo
    }
    
}
