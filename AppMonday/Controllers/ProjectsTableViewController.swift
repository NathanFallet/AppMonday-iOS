//
//  TableViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 17/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit

class ProjectsTableViewController: AppMondayTableViewController {

    var projects = [Project]()
    var loading = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        }
    }
    var hasMore = true
    var timer: Timer?
    weak var delegate: ProjectSelectionDelegate?
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(reloadContent(_:)), for: .valueChanged)
        
        setLoadingScreen()
        loadContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    override func loadContent() {
        loading = true
        ProjectsManager().getList(start: 0, limit: 10) { (projects) in
            self.projects = projects
            self.loading = false
            self.hasMore = true
            self.tableView.reloadData()
            self.removeLoadingScreen()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return projects.count > 0 ? 2 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 ? (projects.count > 0 ? 1 : 0) : (projects.count > 0 ? projects.count - 1 : 0))
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "This week" : "Previous weeks"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = projects[indexPath.section + indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectTableViewCell
            
        cell.name.text = project.name!
        cell.user.text = "Submitted by \(project.user!)"
        cell.date.text = project.publish!
        cell.loadImage(fromURL: project.logo!)
            
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProject = projects[indexPath.section + indexPath.row]
        delegate?.projectSelected(selectedProject)
        
        if let detailViewController = delegate as? ProjectDetailsViewController, let detailNavigationController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = projects.count - 2
        if !loading && hasMore && indexPath.section == 1 && indexPath.row == lastElement {
            loading = true
            ProjectsManager().getList(start: projects.count, limit: 10) { (projects) in
                self.loading = false
                if projects.count > 0 {
                    self.projects += projects
                    self.hasMore = true
                    self.tableView.reloadData()
                } else {
                    self.hasMore = false
                }
            }
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
    
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ProjectDetailsViewController else {
            return
        }
        guard let project = sender as? Project else {
            return
        }
        vc.project = project
     }
     */

}

protocol ProjectSelectionDelegate: class {
    
    func projectSelected(_ newProject: Project)
    
}
