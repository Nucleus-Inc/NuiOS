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
    
    var _id:String?
    var account: UserAccount?
    
    init(account:UserAccount?){
        self.account = account
    }
}

class UserAccount:Account,Codable{
    typealias AccountLocalType = UserAccountLocal
    var local: UserAccountLocal
    var google: UserAccSocialMedia?
    var facebook: UserAccSocialMedia?
        
    init(local:UserAccountLocal,google:UserAccSocialMedia?=nil,facebook:UserAccSocialMedia?=nil){
        self.local = local
        self.google = google
        self.facebook = facebook
    }
}

class UserAccountLocal:AccountLocal,Codable{
    var email:String?
    var photo:String?
    var displayName:String?
    var phoneNumber:String?
    var isActive:Bool = false
    
    init(email:String?,displayName:String?,phoneNumber:String?,photo:String?){
        self.email = email
        self.displayName = displayName
        self.phoneNumber = phoneNumber
        self.photo = photo
    }
}

class UserAccSocialMedia:AccountSocialMedia,Codable{
    var id: String?
    var email:String?
    var photo:String?
    var displayName:String?
}
