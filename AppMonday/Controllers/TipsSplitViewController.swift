//
//  TipsSplitViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 12/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class TipsSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .allVisible
        delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

}
