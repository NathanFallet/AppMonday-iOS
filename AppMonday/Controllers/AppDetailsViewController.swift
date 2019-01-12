//
//  AppDetailsViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 18/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit

class AppDetailsViewController: UIViewController {

    var app: App? {
        didSet {
            loadUI()
        }
    }
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appDescription: UILabel!
    @IBOutlet weak var appUser: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadUI() {
        UIView.performWithoutAnimation {
            view.isHidden = false
            appName.text = app?.name
            appDescription.text = app?.description
            appUser.setTitle(app?.user, for: .normal)
            appUser.layoutIfNeeded()
            loadImage(fromURL: (app?.logo)!)
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AppDetailsViewController: AppSelectionDelegate {
    func appSelected(_ newApp: App) {
        app = newApp
    }
}
