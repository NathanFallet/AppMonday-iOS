//
//  CompetitionDetailsViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 12/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class CompetitionDetailsViewController: UIViewController {
    
    var competition: Competition? {
        didSet {
            UIView.performWithoutAnimation {
                loadViewIfNeeded()
                // Init here
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
