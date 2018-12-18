//
//  App.swift
//  AppMonday
//
//  Created by Nathan FALLET on 18/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import Foundation

class App {
    
    var name: String
    var description: String
    var user: String
    var link: String
    
    init(name: String, description: String, user: String, link: String) {
        self.name = name
        self.description = description
        self.user = user.hasPrefix("@") ? String(user.dropFirst()) : user
        self.link = link
    }
    
}
