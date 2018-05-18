//
//  User.swift
//  AdminForLivingstonFC
//
//  Created by Iza Ledzka on 12/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import Foundation


protocol Member {
    var type: MemberType { get }
    var rowCount: Int { get }
    var sectionTitle: String  { get }
}

enum MemberType {
    case full
    case partial
}

class FullMember: Member {
    var rowCount: Int {
        return users.count
    }
    
    var sectionTitle: String {
        return "Full Membership"
    }
    
    var type: MemberType {
        return .full
    }
    
    var users: [User]
    
    init(_ users: [User]){
        self.users = users
    }
}

class PartialMember: Member {
    var rowCount: Int {
        return users.count
    }
    
    var sectionTitle: String {
        return "Partial Membership"
    }
    
    var type: MemberType {
        return .partial
    }
    
    var users: [User]
    
    init(_ users: [User]){
        self.users = users
    }
}

class User: CustomStringConvertible {
    var description: String { return "User: username: \(self.username), email: \(self.email), password: \(self.password), fullMembership: \(self.fullMembership), BBCApiKey: \(self.BBCApiKey), userApiKey: \(self.userApiKey), created_at: \(self.created_at), updated_at: \(self.updated_at)"
    }
    
    var username: String
    var email: String
    var password: String
    var fullMembership: Bool
    var BBCApiKey: String
    var userApiKey: String
    var created_at: [String:Any]
    var updated_at: [String:Any]
 
    
    
    init?(data: NSDictionary?)
    {
        guard
            let username = data?.value(forKey: "username"),
            let email = data?.value(forKey: "email"),
            let password = data?.value(forKey: "password"),
            let fullMembership = data?.value(forKey: "fullMembership"),
            let BBCApiKey = data?.value(forKey: "BBCApiKey"),
            let userApiKey = data?.value(forKey: "userApiKey"),
            let created_at =  data?.value(forKey: "created_at"),
            let updated_at = data?.value(forKey: "updated_at")
            else { return nil }
        
        self.username = String(describing: username)
        self.email = String(describing: email)
        self.password = password as! String
        self.fullMembership = fullMembership as! Bool
        self.BBCApiKey = BBCApiKey as! String
        self.userApiKey = userApiKey as! String
        self.created_at = created_at as! [String:Any]
        self.updated_at = updated_at as! [String:Any]
        
    }
}
