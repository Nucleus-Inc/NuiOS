//
//  AppSingleton+HelperMethods.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation
import GoogleSignIn
import FBSDKLoginKit

extension AppSingleton{
    
    /**
     This method checks if there is some logged user and tries to get his informations
     */
    func loginSilently(completion:@escaping(Bool)->Void){
        var performCallback:Bool = true
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
        if let id = UserAuth.getUserID(), UserAuth.isUserLogged(){ //some user logged
            if GIDSignIn.sharedInstance().hasAuthInKeychain(){//logged with google
                GIDSignIn.sharedInstance().signInSilently()
                return
            }
            else if let token = FBSDKAccessToken.current(), !token.isExpired{//logged with facebook
                AppSingleton.shared.getInfoDataOf(UserWithID: id) { (success) in
                    if performCallback{
                        completion(success)
                    }
                }
                return
            }
            else{
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
        
        if let token = FBSDKAccessToken.current(), !token.isExpired{
            let login = FBSDKLoginManager()
            login.logOut()
        }
        //clear all user specific locally saved data
    }
    
}
