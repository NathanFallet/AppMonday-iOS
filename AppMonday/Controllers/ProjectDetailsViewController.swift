//
//  AppDetailsViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 18/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit

class ProjectDetailsViewController: UIViewController {

    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var user: UIButton!
    @IBOutlet weak var logo: UIImageView!
    var project: Project? {
        didSet {
            UIView.performWithoutAnimation {
                loadViewIfNeeded()
                placeholder.isHidden = true
                stackview.isHidden = false
                name.text = project?.name
                desc.text = project?.description
                user.setTitle(project?.user, for: .normal)
                user.layoutIfNeeded()
                loadImage(fromURL: (project?.logo)!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openLink(_ sender: Any) {
        let application = UIApplication.shared
        let webURL = URL(string: (project?.link)!)!
        application.open(webURL)
    }
    
    @IBAction func openInstagram(_ sender: Any) {
        let username = project?.user
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
        logo.loadImage(url: imageUrl)
    }

}

extension ProjectDetailsViewController: ProjectSelectionDelegate {
    
    func projectSelected(_ newProject: Project) {
        project = newProject
    }
    
}
