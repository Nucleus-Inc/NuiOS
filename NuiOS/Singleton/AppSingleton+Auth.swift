//
//  AppSingleton+Auth.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation
import UICKeyChainStore
import JWTDecode


extension AppSingleton{
    struct UserAuth{
         static var KEYCHAIN_SERVICE:String = ""
        
         static var GROUP:String?
        
        private static var keychain:UICKeyChainStore{
            guard let group = GROUP else {
                return UICKeyChainStore(service: KEYCHAIN_SERVICE)
            }
            return UICKeyChainStore(service: KEYCHAIN_SERVICE, accessGroup: group)
        }
        
        //MARK: - static funcs
        @discardableResult
        static  func cleanUpKeyChain()->Bool{
            return keychain.removeAllItems()
        }
        
        static func extractAndSaveUserToken(FromRequestHeaders headers:[AnyHashable:Any]?){
            let key = "JWT"
            if let jwt = headers?[key] as? String{
                saveUserToken(token: jwt)
            }
        }
        
        static  func saveUserToken(token:String){
            keychain["user_token"] = token
            //keychain["expiration_date"] = expirationDate.stringFromDate(WithFormat: "dd-MM-yyyy HH:mm:ss")//"dd/MM/yyyy-hh:mm:ss"
        }
        
        
        static  func saveRefreshToken(token:String){
            keychain["refresh_token"] = token
        }
        
        
        
        static  func getToken()->String?{
            return keychain["user_token"]
        }
        
        static  func getRefreshToken()->String?{
            return keychain["refresh_token"]
        }
        
        static  func getBodyOfToken(_ token:String)->[String:Any]?{
            
            do{
                let jwt = try decode(jwt:token)
                print(jwt.body)
                return jwt.body
            }
            catch{
                print("Failed to decode JWT: \(error)")
            }
            return nil
            
        }
        
        static  func isUserTokenValid()->Bool{
            if let token = getToken(){
                do{
                    //let jwt2 = try decode(jwt:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1OTMxOTcyYTI5YzE5NDUwMjgwNDk3MDYiLCJpYXQiOjE0OTY0MjIyNTd9.VJ7xpggY81WbwwuuAhuAyrjAPGUKaYP8lwU0MGhaAaQ")
                    
                    let jwt = try decode(jwt:token)
                    //print(jwt.body)
                    
                    return !jwt.expired
                }
                catch{
                    keychain.removeAllItems()
                    print("Failed to decode JWT: \(error)")
                }
            }
            return false
        }
        
        /**
         Do not call this method directly call instead isThereSomeUserLogged of UpmeSingleton
         */
        static  func isUserLogged()->Bool{
            /*
             let keychain = UICKeyChainStore(service: "com.eti.nucleus.UpmeCustomer.user-token")
             if let dateString = keychain["expiration_date"]{
             if let date = Date.dateFrom(dateString: dateString, AndFormatting: "dd-MM-yyyy HH:mm:ss"){
             return date.timeIntervalSinceNow > 0
             }
             }*/
            
            return isUserTokenValid()
        }
    }
}
