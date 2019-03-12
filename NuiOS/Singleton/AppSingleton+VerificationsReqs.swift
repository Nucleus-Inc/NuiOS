//
//  AppSingleton+Requests.swift
//  NuiOS
//
//  Created by Nucleus on 12/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation


extension AppSingleton{
    enum KeyType{
        case email
        case phoneNumber
    }
    
    func checkAvailabilityOf(Key key:String,KeyType type:KeyType,completion:@escaping(_ success:Bool,_ isAvailable:Bool)->Void){
        
        let endpoint = type == .email ? Verifications.User.emailAvailable(email: key) : Verifications.User.phoneNumberAvailable(phoneNumber: key)
        
        func handler(success:Bool,statusCode:Int?){
            if let code = statusCode{
                switch code{
                case 404://its available
                    completion(true,true)
                case 422://its not available
                    completion(true,false)
                    SwiftMessagesShortcuts.showUnavailableBanner(For: type)
                default:
                    completion(success,false)
                }
            }
            else{//probably success = false
                completion(success,false)
            }
        }
        let onSuccess = Response.OnSuccess(dataType: Data.self, jsonType: [String:Any].self) { (respone, urlResponse) in
            handler(success: true, statusCode: urlResponse?.statusCode)
        }
        
        let onFailure = Response.OnFailure(dataType: ApiError.self, jsonType: Any.self) { (response, urlResponse, error) in
            guard let e = error else{
                handler(success: false, statusCode: urlResponse?.statusCode)
                return
            }
            handler(success: false, statusCode: nil)
            SwiftMessagesShortcuts.showRequestErrorBanner(subtitle: e.localizedDescription)
            //error on request
        }

        try! RequestManager.send(To: endpoint, onSuccess: onSuccess, onFailure: onFailure)
    }

    func checkStrengh(Password pass:String,completion:@escaping(_ success:Bool,_ strength:Int)->Void){
        let endpoint = Verifications.checkStrength(password: pass)
        let onSuccess = Response.OnSuccess(dataType: Data.self, jsonType: [String:Int].self) { (response, urlResponse) in
            var score:Int = 0
            if let value = response.json?["score"]{
                score = value
            }
            completion(true,score)
        }
        let onFailure = Response.OnFailure(dataType: ApiError.self, jsonType: [String:Any].self) { (response, urlResponse, error) in
            completion(false,0)
            SwiftMessagesShortcuts.showRequestErrorBannerIfNeeded(error: error)
        }
        
        try! RequestManager.send(To: endpoint, onSuccess: onSuccess, onFailure: onFailure)
    }
    
}
