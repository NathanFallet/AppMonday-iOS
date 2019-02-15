//
//  CompetitionsTableViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 12/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class CompetitionsTableViewController: AppMondayTableViewController {
    
    weak var delegate: CompetitionSelectionDelegate?
    var playing = [Competition]()
    var coming = [Competition]()
    var ended = [Competition]()
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
        CompetitionsManager().getList(start: 0, limit: 10) { (playing, coming, ended) in
            self.loading = false
            self.removeLoadingScreen()
            if playing.count > 0 || coming.count > 0 || ended.count > 0 {
                self.playing = playing
                self.coming = coming
                self.ended = ended
                self.hasMore = true
                self.tableView.reloadData()
            } else {
                self.hasMore = false
                self.setNothingScreen()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return playing.count + coming.count + ended.count > 0 ? 3 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? playing.count : section == 1 ? coming.count : ended.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Playing" : section == 1 ? "Coming" : "Ended"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let competition = indexPath.section == 0 ? playing[indexPath.row] : indexPath.section == 1 ? coming[indexPath.row] : ended[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "competitionCell", for: indexPath) as! CompetitionTableViewCell
        
        cell.name.text = competition.name
        cell.date.text = "\(competition.start ?? "Unknown") - \(competition.end ?? "Unknown")"
        cell.status.backgroundColor = competition.playing! ? UIColor.green : competition.coming! ? UIColor.orange : UIColor.red
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCompetition = indexPath.section == 0 ? playing[indexPath.row] : indexPath.section == 1 ? coming[indexPath.row] : ended[indexPath.row]
        delegate?.competitionSelected(selectedCompetition)
        
        if let detailViewController = delegate as? CompetitionDetailsViewController, let detailNavigationController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = ended.count - 2
        if !loading && hasMore && indexPath.section == 2 && indexPath.row == lastElement {
            loading = true
            CompetitionsManager().getList(start: playing.count + coming.count + ended.count, limit: 10) { (playing, coming, ended) in
                self.loading = false
                if playing.count > 0 || coming.count > 0 || ended.count > 0 {
                    self.playing += playing
                    self.coming += coming
                    self.ended += ended
                    self.hasMore = true
                    self.tableView.reloadData()
                } else {
                    self.hasMore = false
                }
            }
        }
    }

}

protocol CompetitionSelectionDelegate: class {
    
    func competitionSelected(_ newCompetition: Competition)
    
}
