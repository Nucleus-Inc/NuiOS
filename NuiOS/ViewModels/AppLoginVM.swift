//
//  AppLoginVM.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation


class AppLoginVM:LoginVCViewModel{
    
    func performLogin(Username user: String, Password password: String, completion: @escaping (Bool) -> Void) {
        
        AppSingleton.shared.signinWith(Username: user, Password: password, completion: completion)
        
    }
    
}
