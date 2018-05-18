//
//  UsersTableViewController.swift
//  AdminForLivingstonFC
//
//  Created by Iza Ledzka on 13/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    var members = [Member]()
    
    private var users = [User]() {
        didSet {
            for user in users {
                if user.fullMembership == true {
                    fullMembers.append(user)
                } else {
                    partialMembers.append(user)
                }
            }
            members.append(FullMember(fullMembers))
            members.append(PartialMember(partialMembers))
            
            //adjust row height to fill up the tableview
            if tableView.frame.height / CGFloat(users.count) > tableView.rowHeight {
                tableView.rowHeight = tableView.frame.height / CGFloat(users.count)
            }
            
            self.tableView.reloadData()
        }
    }
    
    private var fullMembers = [User]()
    private var partialMembers = [User]()
    
    private var alert: UIAlertController?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "USERS"
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //When on ipad
        if members.isEmpty {
            doApiRequestUsers()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return members.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members[section].rowCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell {
            cell.userCount = indexPath.row + 1
            
            let userType = members[indexPath.section]
            switch userType.type {
            case .full:
                let user = (userType as? FullMember)?.users[indexPath.row]
                cell.user = user
            case .partial:
                let user = (userType as? PartialMember)?.users[indexPath.row]
                cell.user = user
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return members[section].sectionTitle
    }
}


