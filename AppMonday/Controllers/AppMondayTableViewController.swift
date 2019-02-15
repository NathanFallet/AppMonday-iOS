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
    let nothingView = UIView()
    let nothingLabel = UILabel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
        if let selectedRow = selectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    func loadContent() {}
    
    @objc func reloadContent(_ sender: Any){
        loadContent()
        if refreshControl != nil {
            refreshControl?.endRefreshing()
        }
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
    
    func setNothingScreen() {
        let width: CGFloat = 300
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        nothingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        nothingLabel.textAlignment = .center
        nothingLabel.text = "This content is temporarily unavailable"
        nothingLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
        
        nothingView.addSubview(nothingLabel)
        
        tableView.addSubview(nothingView)
        tableView.separatorStyle = .none
    }

}
