//
//  AppTableViewCell.swift
//  AppMonday
//
//  Created by Nathan FALLET on 18/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var date: UILabel!
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
        logo.loadImage(url: imageUrl)
    }

}
