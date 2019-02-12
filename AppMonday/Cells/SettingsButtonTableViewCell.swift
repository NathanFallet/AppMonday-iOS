//
//  SettingsButtonTableViewCell.swift
//  Extopy
//
//  Created by Nathan FALLET on 23/01/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class SettingsButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    var handler: () -> Void = { () in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onClick(_ sender: Any) {
        handler()
    }

}
