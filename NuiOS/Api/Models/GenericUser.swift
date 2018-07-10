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
    associatedtype ProfileType:Profile
    
    var account:AccountType?{get set}
    var profile:ProfileType?{get set}
}

public protocol Account{
    var email:String?{get set}
    var name:String?{get set}
    var phoneNumber:String?{get set}
    var isActive:Bool{get set}
}

public protocol Profile{
    var pictureUrl:String?{get set}
}
