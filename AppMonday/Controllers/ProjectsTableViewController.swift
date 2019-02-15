//
//  TableViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 17/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit

class ProjectsTableViewController: AppMondayTableViewController {

    weak var delegate: ProjectSelectionDelegate?
    var projects = [Project]()
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
        ProjectsManager().getList(start: 0, limit: 10) { (projects) in
            self.loading = false
            self.removeLoadingScreen()
            if projects.count > 0 {
                self.projects = projects
                self.hasMore = true
                self.tableView.reloadData()
            } else {
                self.hasMore = false
                self.setNothingScreen()
            }
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

}

protocol ProjectSelectionDelegate: class {
    
    func projectSelected(_ newProject: Project)
    
}
