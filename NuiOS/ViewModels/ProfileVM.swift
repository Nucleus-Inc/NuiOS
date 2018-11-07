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
        self.email = user?.account?.local.email
        if let unmaskedPhone = user?.account?.local.phoneNumber, !unmaskedPhone.isEmpty{
            self.phoneNumber = PhoneNumber.BR.mask(text: unmaskedPhone)
        }
        self.name = user?.account?.local.displayName
        self.pictureUrl = user?.account?.local.photo
    }
    
    func updateName(newName: String, completion: ((Bool) -> Void)?) {
        AppSingleton.shared.updateName(name: newName) { (success) in
            completion?(success)
        }
    }
    
    func updateProfilePicture(_ image: UIImage, completion: ((Bool) -> Void)?) {
        self.profilePicture = image
        let urlString = "https://unsplash.it/200/200/?random"
        AppSingleton.shared.updatePicture(ImageURL: urlString, completion: completion)
    }
}
