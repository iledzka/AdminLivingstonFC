//
//  UserTableViewCell.swift
//  AdminForLivingstonFC
//
//  Created by Iza Ledzka on 13/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNumberLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User? {
        didSet {
            configureUI()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellNumberLabel.text = nil
        usernameLabel.text = nil
        emailLabel.text = nil
    }
    //keeps count of the cells generated
    var userCount: Int?
    
    
    private func configureUI() {
        if let unwrappedUser = user, let userNo = userCount {
            self.cellNumberLabel.text = String(describing: userNo)
            self.usernameLabel.text = unwrappedUser.username
            self.emailLabel.text = unwrappedUser.email
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
