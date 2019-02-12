//
//  AppMondayTableViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 12/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class AppMondayTableViewController: UITableViewController {

    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isDarkMode() ? enableDarkMode() : disableDarkMode()
    }
    
    func loadContent() {}
    
    @objc func reloadContent(_ sender: Any){
        loadContent()
        if refreshControl != nil {
            refreshControl?.endRefreshing()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    func setLoadingScreen() {
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
        tableView.separatorStyle = .none
    }
    
    func removeLoadingScreen() {
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        tableView.separatorStyle = .singleLine
    }
    
    func isDarkMode() -> Bool {
        let datas = Foundation.UserDefaults.standard
        
        if(datas.value(forKey: "isDarkMode") != nil){
            return datas.value(forKey: "isDarkMode") as! Bool
        }
        return false
    }
    
    @objc func darkModeEnabled(_ notification: Notification) {
        enableDarkMode()
        self.tableView.reloadData()
    }
    
    @objc func darkModeDisabled(_ notification: Notification) {
        disableDarkMode()
        self.tableView.reloadData()
    }
    
    open func enableDarkMode() {
        self.view.backgroundColor = CustomColor.darkTableBackground
        self.tableView.backgroundColor = CustomColor.darkTableBackground
        self.tableView.separatorColor = CustomColor.darkSeparator
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.view.backgroundColor = CustomColor.darkBackground
        self.navigationController?.navigationBar.tintColor = CustomColor.darkActive
        self.loadingLabel.textColor = CustomColor.darkText
        self.spinner.style = .white
    }
    
    open func disableDarkMode() {
        self.view.backgroundColor = CustomColor.lightTableBackground
        self.tableView.backgroundColor = CustomColor.lightTableBackground
        self.tableView.separatorColor = CustomColor.lightSeparator
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.view.backgroundColor = CustomColor.lightBackground
        self.navigationController?.navigationBar.tintColor = CustomColor.lightActive
        self.loadingLabel.textColor = CustomColor.lightText
        self.spinner.style = .gray
    }

}
