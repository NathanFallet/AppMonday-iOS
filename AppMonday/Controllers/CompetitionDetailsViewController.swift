//
//  CompetitionDetailsViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 12/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class CompetitionDetailsViewController: UIViewController {
    
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var criterias: UILabel!
    var competition: Competition? {
        didSet {
            UIView.performWithoutAnimation {
                loadViewIfNeeded()
                placeholder.isHidden = true
                stackview.isHidden = false
                name.text = competition?.name
                date.text = "\(competition?.start ?? "Unknown") - \(competition?.end ?? "Unknown")"
                desc.text = competition?.description
                criterias.text = competition?.criterias
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension CompetitionDetailsViewController: CompetitionSelectionDelegate {
    
    func competitionSelected(_ newCompetition: Competition) {
        competition = newCompetition
    }
    
}
