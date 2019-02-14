//
//  SettingsTableViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 12/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class SettingsTableViewController: AppMondayTableViewController {
    
    var sections = [SettingsSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContent()
    }
    
    override func loadContent() {
        sections = []

        sections += [SettingsSection(name: "What is AppMonday?", elements: [
            SettingsElementButton(id: "moreInfo", text: "Check out our website for more!") { () in
                UIApplication.shared.open(URL(string: "https://www.appmonday.xyz/")!)
            }
        ])]
        
        sections += [SettingsSection(name: "Instragram accounts", elements: [
            SettingsElementButton(id: "instagram_nathanfallet", text: "@nathanfallet") { () in
                let appURL = URL(string: "instagram://user?username=nathanfallet")!
                let application = UIApplication.shared
                
                if application.canOpenURL(appURL) {
                    application.open(appURL)
                } else {
                    let webURL = URL(string: "https://instagram.com/nathanfallet")!
                    application.open(webURL)
                }
            },
            SettingsElementButton(id: "instagram_code.community", text: "@code.community") { () in
                let appURL = URL(string: "instagram://user?username=code.community")!
                let application = UIApplication.shared
                
                if application.canOpenURL(appURL) {
                    application.open(appURL)
                } else {
                    let webURL = URL(string: "https://instagram.com/code.community")!
                    application.open(webURL)
                }
            }
        ])]
        
        sections += [SettingsSection(name: "Developer", elements: [
            SettingsElementButton(id: "moreApps", text: "More apps by our team") { () in
                UIApplication.shared.open(URL(string: "https://itunes.apple.com/us/developer/groupe-minaste/id1378426984")!)
            },
            SettingsElementButton(id: "donate", text: "Donate") { () in
                UIApplication.shared.open(URL(string: "https://www.paypal.me/NathanFallet")!)
            }
        ])]
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].elements.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = sections[indexPath.section].elements[indexPath.row]
        
        if let e = element as? SettingsElementLabel {
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! SettingsLabelTableViewCell
            
            cell.label.text = e.text
            
            return cell
        } else if let e = element as? SettingsElementSwitch {
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SettingsSwitchTableViewCell
            
            cell.id = e.id
            cell.label.text = e.text
            
            let datas = Foundation.UserDefaults.standard
            var enable = e.d
            if(datas.value(forKey: e.id) != nil){
                enable = datas.value(forKey: e.id) as! Bool
            }
            cell.switchElement.setOn(enable, animated: false)
            
            return cell
        } else if let e = element as? SettingsElementButton {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! SettingsButtonTableViewCell
            
            cell.button.setTitle(e.text, for: .normal)
            cell.handler = e.handler
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
