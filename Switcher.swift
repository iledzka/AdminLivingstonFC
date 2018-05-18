//
//  Switcher.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 09/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC(){
        
        let status = UserDefaultsManager.isLoggedIn()
        var rootVC : UIViewController?
        
        if(status == true){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplitViewController") as! UISplitViewController
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        
    }
}

