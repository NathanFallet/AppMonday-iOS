//
//  ViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 17/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var appName: UITextField!
    @IBOutlet weak var appDescription: UITextField!
    @IBOutlet weak var appUser: UITextField!
    @IBOutlet weak var appLink: UITextField!
    @IBOutlet weak var appLogo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func send(_ sender: Any) {
        if appName.text!.isEmpty || appDescription.text!.isEmpty || appUser.text!.isEmpty || appLink.text!.isEmpty {
            Utils.displayAlert(NSLocalizedString("error_all_fields_required", value: "All fields are required!", comment: "All fields are required!"), self)
            return
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        Utils.query(post: ["method": "Web:submitApp()", "name": appName.text!, "description": appDescription.text!, "user": appUser.text!, "link": appLink.text!, "logo": appLogo.text!]) { (data: Data) in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    if parseJSON["error"] == nil {
                        Utils.displayAlert(NSLocalizedString("success", value: "Your app has been submitted! Follow us on Instragram to see it in our story.", comment: "Main error"), self)
                    } else if parseJSON["error"] as! String == "error_all_fields_required" {
                        Utils.displayAlert(NSLocalizedString("error_all_fields_required", value: "All fields are required!", comment: "Please fill all inputs with correct values!"), self)
                    } else if parseJSON["error"] as! String == "error_name_or_link_already_taken" {
                        Utils.displayAlert(NSLocalizedString("error_name_or_link_already_taken", value: "An app with this name or this link was already submitted!", comment: "All fields are required!"), self)
                    } else {
                        Utils.displayAlert(NSLocalizedString("error", value: "We are sorry but something went wrong...", comment: "Main error"), self)
                    }
                } else {
                    Utils.displayAlert(NSLocalizedString("error", value: "We are sorry but something went wrong...", comment: "Main error"), self)
                }
            } catch {
                print(String(describing: error))
                Utils.displayAlert(NSLocalizedString("error", value: "We are sorry but something went wrong...", comment: "Main error"), self)
            }
        }
    }
    
}

