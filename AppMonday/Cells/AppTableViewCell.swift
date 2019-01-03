//
//  AppTableViewCell.swift
//  AppMonday
//
//  Created by Nathan FALLET on 18/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit

class AppTableViewCell: UITableViewCell {

    @IBOutlet weak var appname: UILabel!
    @IBOutlet weak var appuser: UILabel!
    @IBOutlet weak var appdate: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImage(fromURL imageUrl: String) {
        logo.clipsToBounds = true
        logo.layer.cornerRadius = 13
        
        Utils.loadImage(url: imageUrl) { (_ image: UIImage) in
            self.logo.image = image
        }
    }

}
