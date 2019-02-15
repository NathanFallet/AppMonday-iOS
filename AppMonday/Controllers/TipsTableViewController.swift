//
//  TipsTableViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 12/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class TipsTableViewController: AppMondayTableViewController {
    
    weak var delegate: TipSelectionDelegate?
    var tips = [Tip]()
    var hasMore = true
    var loading = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(reloadContent(_:)), for: .valueChanged)
        
        setLoadingScreen()
        loadContent()
    }
    
    override func loadContent() {
        loading = true
        TipsManager().getList(start: 0, limit: 10) { (tips) in
            self.loading = false
            self.removeLoadingScreen()
            if tips.count > 0 {
                self.tips = tips
                self.hasMore = true
                self.tableView.reloadData()
            } else {
                self.hasMore = false
                self.setNothingScreen()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tips.count > 0 ? 2 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 ? (tips.count > 0 ? 1 : 0) : (tips.count > 0 ? tips.count - 1 : 0))
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "This week" : "Previous weeks"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tip = tips[indexPath.section + indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tipCell", for: indexPath) as! TipTableViewCell
        
        cell.name.text = tip.name!
        cell.date.text = tip.publish!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTip = tips[indexPath.section + indexPath.row]
        delegate?.tipSelected(selectedTip)
        
        if let detailViewController = delegate as? TipDetailsViewController, let detailNavigationController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = tips.count - 2
        if !loading && hasMore && indexPath.section == 1 && indexPath.row == lastElement {
            loading = true
            TipsManager().getList(start: tips.count, limit: 10) { (tips) in
                self.loading = false
                if tips.count > 0 {
                    self.tips += tips
                    self.hasMore = true
                    self.tableView.reloadData()
                } else {
                    self.hasMore = false
                }
            }
        }
    }

}

protocol TipSelectionDelegate: class {
    
    func tipSelected(_ newTip: Tip)
    
}
