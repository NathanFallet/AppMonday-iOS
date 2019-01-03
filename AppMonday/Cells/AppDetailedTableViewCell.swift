//
//  AppDetailedTableViewCell.swift
//  AppMonday
//
//  Created by Nathan FALLET on 03/01/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class AppDetailedTableViewCell: UITableViewCell {

    var app: App?
    @IBOutlet weak var appname: UILabel!
    @IBOutlet weak var appuser: UIButton!
    @IBOutlet weak var appdate: UILabel!
    @IBOutlet weak var appdescription: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func openLink(_ sender: Any) {
        let application = UIApplication.shared
        let webURL = URL(string: (app?.link)!)!
        application.open(webURL)
    }
    
    @IBAction func openInstagram(_ sender: Any) {
        let username = app?.user
        let appURL = URL(string: "instagram://user?username=\(username ?? "")")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = URL(string: "https://instagram.com/\(username ?? "")")!
            application.open(webURL)
        }
    }
    
    func loadImage(fromURL imageUrl: String) {
        logo.clipsToBounds = true
        logo.layer.cornerRadius = 13
        
        Utils.loadImage(url: imageUrl) { (_ image: UIImage) in
            self.logo.image = image
        }
    }

}
