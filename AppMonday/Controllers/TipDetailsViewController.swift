//
//  TipDetailsViewController.swift
//  AppMonday
//
//  Created by Nathan FALLET on 12/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class TipDetailsViewController: UIViewController {
    
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    var tip: Tip? {
        didSet {
            UIView.performWithoutAnimation {
                loadViewIfNeeded()
                placeholder.isHidden = true
                stackview.isHidden = false
                name.text = tip?.name
                desc.text = tip?.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension TipDetailsViewController: TipSelectionDelegate {
    
    func tipSelected(_ newTip: Tip) {
        tip = newTip
    }
    
}
