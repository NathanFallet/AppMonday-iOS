//
//  SettingsSection.swift
//  Extopy
//
//  Created by Nathan FALLET on 25/01/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class SettingsSection {
    
    var name: String
    var elements: [SettingsElement]
    
    init(name: String, elements: [SettingsElement]) {
        self.name = name
        self.elements = elements
    }
    
}
