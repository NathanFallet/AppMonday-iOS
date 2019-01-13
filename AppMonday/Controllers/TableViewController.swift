//
//  TableViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 17/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var apps = [App]()
    var loadingMore = false
    var hasMore = true
    var timer: Timer?
    weak var delegate: AppSelectionDelegate?
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(reloadApps(_:)), for: .valueChanged)
        
        loadApps()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            var dateInfo = DateComponents()
            dateInfo.hour = 12
            dateInfo.minute = 0
            dateInfo.weekday = 2
            dateInfo.timeZone = TimeZone(identifier: "Europe/Paris")
            let date = Calendar(identifier: .gregorian).nextDate(after: Date(), matching: dateInfo, matchingPolicy: .nextTime, direction: .forward)!
            
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            formatter.allowedUnits = [.day, .hour, .minute, .second]
            self.label.text = "Time before next AppMonday:\n\(formatter.string(from: Date(), to: date)!)"
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    @objc func reloadApps(_ sender: Any){
        loadApps()
    }
    
    func loadApps() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        Utils.query(post: ["method": "Web:getApps()", "start": loadingMore ? apps.count : 0, "limit": 10]) { (data: Data) in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    if parseJSON["success"] as! Bool {
                        if !self.loadingMore {
                            self.apps.removeAll()
                            self.hasMore = true
                        }
                        var count = 0
                        for (_, obj) in parseJSON.sorted(by: {($0.0 as! NSString).integerValue < ($1.0 as! NSString).integerValue}) {
                            if let app = obj as? NSDictionary {
                                self.apps += [App(name: app["name"] as! String, description: app["description"] as! String, user: app["user"] as! String, link: app["link"] as! String, date: app["publish"] as! String, logo: app["logo"] as! String)]
                                count += 1
                            }
                        }
                        if count == 0 {
                            self.hasMore = false
                        }
                    }
                } else {
                    print("error serv")
                }
            } catch {
                print(String(describing: error))
                //self.displayAlert(NSLocalizedString("error", value: "Error while sending data to the server! Please try again later", comment: "Main error"))
            }
        }
        Utils.addInMain {
            self.loadingMore = false
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let app = apps[indexPath.row]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "appDetailedCell", for: indexPath) as! AppDetailedTableViewCell
            
            cell.app = app
            cell.appname.text = app.name
            cell.appuser.setTitle(app.user, for: .normal)
            cell.appdate.text = app.date
            cell.appdescription.text = app.description
            cell.loadImage(fromURL: app.logo)
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "appCell", for: indexPath) as! AppTableViewCell
            
            cell.appname.text = app.name
            cell.appuser.text = "Submitted by \(app.user)"
            cell.appdate.text = app.date
            cell.loadImage(fromURL: app.logo)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedApp = apps[indexPath.row]
        delegate?.appSelected(selectedApp)
        
        if let detailViewController = delegate as? AppDetailsViewController, let detailNavigationController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = apps.count - 1
        if !loadingMore && hasMore && indexPath.row == lastElement {
            loadingMore = true
            loadApps()
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? AppDetailsViewController else {
            return
        }
        guard let app = sender as? App else {
            return
        }
        vc.app = app
    }

}

protocol AppSelectionDelegate: class {
    func appSelected(_ newApp: App)
}
