//
//  User.swift
//  NuiOS
//
//  Created by Nucleus on 10/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation


class User:GenericUser,Codable{
    typealias AccountType = UserAccount
    typealias ProfileType = UserProfile
    
    var account: UserAccount?
    var profile: UserProfile?
    
    init(account:UserAccount?,profile:UserProfile?){
        self.account = account
        self.profile = profile
    }
}

class UserProfile:Profile,Codable{
    var pictureUrl: String?
}

class UserAccount:Account,Codable{
    var email: String?
    
    var name: String?
    
    var phoneNumber: String?
    
    var isActive: Bool = false

}
