//
//  AppSingleton+HelperMethods.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation

extension AppSingleton{
    
    /**
     This method checks if there is some JWT saved, if yes tries to get
     */
    func loginSilently(completion:@escaping(Bool)->Void){
        var performCallback:Bool = true
        if UserAuth.isUserLogged(), let jwt = UserAuth.getToken(), let body = UserAuth.getBodyOfToken(jwt), let id = body["_id"] as? String{
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
        }
        else{
            completion(false)
        }
    }
    
    func logout(){
        self.user = nil
        UserAuth.cleanUpKeyChain()
        //clear all user specific locally saved data
    }
    
}
