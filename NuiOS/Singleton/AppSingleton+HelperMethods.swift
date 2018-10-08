//
//  AppSingleton+HelperMethods.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation
import GoogleSignIn

extension AppSingleton{
    
    /**
     This method checks if there is some logged user and tries to get his informations
     */
    func loginSilently(completion:@escaping(Bool)->Void){
        var performCallback:Bool = true
        if let id = UserAuth.getUserID(){ //some user logged
            if GIDSignIn.sharedInstance().hasAuthInKeychain(){
                GIDSignIn.sharedInstance().signInSilently()
                return
            }
            else if UserAuth.isUserLocalLogged() {
                /*
                 if there is locally saved user {
                 load locally data
                 
                 if user.isActive{
                 performCallback = false
                 completion(true)
                 }
                 }
                 */
                //update locally data with remotelly data
                AppSingleton.shared.getInfoDataOf(UserWithID: id) { (success) in
                    if performCallback{
                        completion(success)
                    }
                }
                return
            }
        }
        logout()
        completion(false)
    }
    
    /**
     This method performs all actions to remove any reference to last logged user, for example JWT, Google Session, Facebook Session, local saved user informations.
     */
    func logout(){
        self.user = nil
        UserAuth.cleanUpKeyChain()
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            GIDSignIn.sharedInstance().signOut()
        }
        //clear all user specific locally saved data
    }
    
}
