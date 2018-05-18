//
//  SplitViewController.swift
//  AdminForLivingstonFC
//
//  Created by Iza Ledzka on 13/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController,
UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }
    
    // UISplitViewControllerDelegate used to collapse the detail view and show only master view on iphone
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }
}
