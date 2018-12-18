//
//  AppDetailsViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 18/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit

class AppDetailsViewController: UIViewController {

    var app: App?
    @IBOutlet weak var appDescription: UILabel!
    @IBOutlet weak var appUser: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = app?.name
        appDescription.text = app?.description
        appUser.setTitle(app?.user, for: .normal)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
