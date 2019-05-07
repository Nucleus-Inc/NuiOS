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

enum LoggedBy{
    case google
    case facebook
    case local
}

extension AppSingleton{
    
    /**
     This method checks if there is some logged user and tries to get his informations
     */
    func loginSilently(completion:@escaping(Bool,LoggedBy?)->Void){
        var waitForLoadProfile:Bool = true
        var loggedBy:LoggedBy?
        /*
         if there is locally saved user {
         load locally data
         
         if user.isActive{
         waitForLoadProfile = false
         }
         }
         */
        
        //update locally data with remotelly data
        if let id = UserAuth.getUserID(), UserAuth.isUserLogged(){ //some user logged
            if GIDSignIn.sharedInstance().hasAuthInKeychain(){//logged with google
                loggedBy = .google
                GIDSignIn.sharedInstance().signInSilently()
                completion(true,.google)
                return
            }
            else{
                if let token = AccessToken.current, !token.isExpired{//logged with facebook
                    loggedBy = .facebook
                }
                else{
                    loggedBy = .local
                }
                
                AppSingleton.shared.getInfoDataOf(UserWithID: id) { (success) in
                    if waitForLoadProfile{
                        completion(success,loggedBy)
                    }
                }
                
                if !waitForLoadProfile{
                    completion(true,loggedBy)
                }
                return
            }
        }
        
        logout()
        completion(false,loggedBy)
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
        
        if let token = AccessToken.current, !token.isExpired{
            let login = LoginManager()
            login.logOut()
        }
        //clear all user specific locally saved data
    }
    
}
