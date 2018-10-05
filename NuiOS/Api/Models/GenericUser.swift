//
//  User.swift
//  MeaStartIntegration
//
//  Created by Nucleus on 09/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation

public protocol GenericUser{
    associatedtype AccountType:Account
    var account:AccountType?{get set}
}

public protocol Account{
    associatedtype AccountLocalType:AccountLocal
    var local:AccountLocalType{get set}
}

public protocol AccountLocal{
    var email:String?{get set}
    var photo:String?{get set}
    var displayName:String?{get set}
    var phoneNumber:String?{get set}
    var isActive:Bool{get set}
}

public protocol AccountSocialMedia{
    var id:String?{get set}
    var photo:String?{get set}
    var email:String?{get set}
    var displayName:String?{get set}
}
