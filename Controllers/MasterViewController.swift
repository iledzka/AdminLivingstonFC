//
//  MasterViewController.swift
//  AdminForLivingstonFC
//
//  Created by Iza Ledzka on 13/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit
import MessageUI


//  This controller configues the main view of the app
class MasterViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        doApiRequestUsers()
        emailAllButton.layer.cornerRadius = 10
        logOutButton.layer.cornerRadius = 10
        showAllButton.layer.cornerRadius = 10
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
    }
    
    
    var members = [Member]()
    
    private var users = [User]() {
        didSet {
            for user in users {
                if user.fullMembership == true {
                    fullMembers.append(user)
                } else {
                    partialMembers.append(user)
                }
                emailsAllUsers.append(user.email)
            }
            members.append(FullMember(fullMembers))
            members.append(PartialMember(partialMembers))
        }
    }
    
    private var fullMembers = [User]()
    private var partialMembers = [User]()

    private func doApiRequestUsers() {
        //request Users from API
        LivingstonFCAPIManager.sharedInstance.getAllUsers(onSuccess: { [weak self] users in
            DispatchQueue.main.async {
                self?.users.append(contentsOf: users)
            }
            }, onFailure: { [weak self] error in
                DispatchQueue.main.async {
                    var errorMsg = error.localizedDescription
                    if let error = error as? ErrorResponse {
                        switch error {
                        case .internalServerError:
                            errorMsg = "There is something wrong on our side. Please try again later."
                        case .unauthorized:
                            errorMsg = "The username/email address or password is invalid."
                        case .unprocessableEntity:
                            errorMsg = "Could not process your request."
                        case .connectionFailed:
                            errorMsg = "It appears you are offline. Connect to internet to log in."
                        case .invalidRequest:
                            errorMsg = "Invalid Request"
                        }
                    }
                    
                    self?.alert = CustomAlert.unsuccessfulLogin(errorMsg)
                }
        })
    }
    
    private var alert: UIAlertController?
    
    @IBOutlet weak var emailAllButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var showAllButton: UIButton!
    
    @IBAction func showAllButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "UsersTable", sender: self)
        
    }
    
    var emailsAllUsers = [String]()
    
    @IBAction func emailAllButtonPressed(_ sender: Any) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        guard MFMailComposeViewController.canSendMail(), !emailsAllUsers.isEmpty else { return }
        composeVC.setBccRecipients(emailsAllUsers)
        composeVC.setSubject("Livingston FC")
        composeVC.setMessageBody("Hello!\nThis is an important update about Livingston FC.", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        UserDefaultsManager.logOut()
    }
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        if segue.identifier == "UsersTable", let usersTableVC = destinationViewController as? UsersTableViewController {
            usersTableVC.members = members
            
        }
    }
    
    //Display Master View Controller first when on iPhone
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contents == self {
            if let _ = secondaryViewController.contents as? UsersTableViewController {
                return true
            }
        }
        return false
    }

}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
