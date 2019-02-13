//
//  TipTableViewCell.swift
//  AppMonday
//
//  Created by Nathan FALLET on 13/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class TipTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
