//
//  SettingsSwitchTableViewCell.swift
//  Extopy
//
//  Created by Nathan FALLET on 23/01/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class SettingsSwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switchElement: UISwitch!
    var id = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onChange(_ sender: Any) {
        let datas = Foundation.UserDefaults.standard
        datas.set(switchElement.isOn, forKey: id)
        datas.synchronize()
    }

}
