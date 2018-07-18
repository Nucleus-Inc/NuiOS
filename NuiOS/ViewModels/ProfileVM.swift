//
//  ProfileVM.swift
//  NuiOS
//
//  Created by Nucleus on 16/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation
import UIKit

class ProfileVM:ProfileVCViewModel{
    
    var user: User?{
        return AppSingleton.shared.user
    }
    
    var email: String?
    var phoneNumber: String?
    var name: String?
    
    var profilePicture: UIImage?
    var pictureUrl: String?
    
    init(){
        reloadValues()
    }
    
    func reloadValues() {
        self.email = user?.account?.email
        if let unmaskedPhone = user?.account?.phoneNumber{
            self.phoneNumber = PhoneNumber.BR.mask(number: unmaskedPhone)
        }
        self.name = user?.account?.name
        self.pictureUrl = user?.profile?.pictureUrl
    }
    
    func updateName(newName: String, completion: ((Bool) -> Void)?) {
        AppSingleton.shared.updateName(name: newName) { (success) in
            completion?(success)
        }
    }
    
    func updateProfilePicture(_ image: UIImage, completion: ((Bool) -> Void)?) {
        self.profilePicture = image
        let urlString = "https://unsplash.it/200/200/?random"
        AppSingleton.shared.updateProfilePicture(ImageURL: urlString, completion: completion)
    }
}
