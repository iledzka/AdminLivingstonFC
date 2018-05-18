//
//  CustomAlertController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 11/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

struct CustomAlert {
    
    static let tintColour = UIColor(red: 237/255, green: 116/255, blue: 47/255, alpha: 1)
    
    static let offlineAlert: UIAlertController = {
        let alert = UIAlertController(title: "No internet connection", message: "Please connect to the internet to view the content.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        alert.view.tintColor = tintColour
        return alert
    }()
    
    static func unsuccessfulLogin(_ errorMsg: String)-> UIAlertController {
        let alert = UIAlertController(title: "Could Not Connect", message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        alert.view.tintColor = tintColour
        return alert
    }
    
    static func noAdminPrivileges()-> UIAlertController {
        let alert = UIAlertController(title: "Unauthorised account", message: "Your accound doesn't have admin privileges. Please contact Administrator.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        alert.view.tintColor = tintColour
        return alert
    }
}
