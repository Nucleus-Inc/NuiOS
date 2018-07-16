//
//  AppSingleton+UserReqs.swift
//  NuiOS
//
//  Created by Nucleus on 12/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation

extension AppSingleton{
    //MARK: - Login
    private func processOnFailure(apiError:ApiError?,reqError:Error?){
        guard let e = reqError else{
            //check error on response.data
            if let apiError = apiError{
                NotificationBannerShortcuts.showApiErrorBanner(ApiError: apiError)
            }
            return
        }
        NotificationBannerShortcuts.showRequestErrorBanner(subtitle: e.localizedDescription)
    }
    
    func signinWith(Username username:String,Password pass:String,completion:@escaping(_ success:Bool)->Void){
        let endpoint = Users.signin(email: username, password: pass)
        let onSuccess = Response.OnSuccess(dataType: User.self, jsonType:Any.self) { (response, urlResponse) in
            UserAuth.extractAndSaveUserToken(FromRequestHeaders: urlResponse?.allHeaderFields)
            self.user = response.data
            completion(true)
        }
        let onFailure = Response.OnFailure(dataType: ApiError.self, jsonType: Any.self) { (response, urlResponse, reqError) in
            completion(false)
            guard let e = reqError else{
                //see response.data
                NotificationBannerShortcuts.showLoginErrBanner()
                return
            }
            NotificationBannerShortcuts.showRequestErrorBanner(subtitle: e.localizedDescription)
        }
        
        try! RequestManager.send(To: endpoint, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    //MARK: - SignUp
    func signupUser(Params params:[String:Any],completion:@escaping(_ success:Bool)->Void){
        let endpoint = Users.Account.signup(params: params)
        let onSuccess = Response.OnSuccess(dataType: User.self, jsonType: [String:Any].self) { (response, urlResponse) in
            UserAuth.extractAndSaveUserToken(FromRequestHeaders: urlResponse?.allHeaderFields)
            print(urlResponse?.allHeaderFields ?? "")
            self.user = response.data
            completion(true)
        }
        let onFailure = Response.OnFailure(dataType: ApiError.self, jsonType: Any.self) { (response, urlResponse, reqError) in
            completion(false)
            guard let e = reqError else{
                //check error on response.data
                return
            }
            NotificationBannerShortcuts.showRequestErrorBanner(subtitle: e.localizedDescription)
        }
        
        try! RequestManager.send(To: endpoint, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func reqActivationCode(ForUserID id:String,By by:CodeTransport,completion:((_ success:Bool)->Void)?=nil){
        let transport:Users.Account.Transport = by == .email ? .email : .sms
        let endpoint = Users.Account.requestActivationCode(userID: id, by: transport)
        let onSuccess = Response.OnSuccess(dataType: Data.self, jsonType: Any.self) { (response, urlResponse) in
            print(urlResponse?.allHeaderFields ?? "no header fields")
            completion?(true)
            NotificationBannerShortcuts.showReqActCodeSuccess(For: by)
        }
        let onFailure = Response.OnFailure(dataType: ApiError.self, jsonType: Any.self) { (response, urlResponse, reqError) in
            completion?(false)
            guard let e = reqError else{
                //check error on response.data
                print(response.json ?? "no api error")
                return
            }
            NotificationBannerShortcuts.showRequestErrorBanner(subtitle: e.localizedDescription)
        }
        try! RequestManager.send(To: endpoint, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func activateAccount(OfUserID id:String,WithCode code:String,completion:@escaping(_ success:Bool,_ validCode:Bool)->Void){
        let endpoint = Users.Account.activateAccount(userID: id, code: code)
        let onSuccess = Response.OnSuccess(dataType: User.self, jsonType: [String:Any].self) { (response, urlResponse) in
            UserAuth.extractAndSaveUserToken(FromRequestHeaders: urlResponse?.allHeaderFields)
            self.user = response.data
            completion(true,true)
        }
        let onFailure = Response.OnFailure(dataType: ApiError.self, jsonType: Any.self) { (response, urlResponse, reqError) in
            completion(false,false)
            self.processOnFailure(apiError: response.data, reqError: reqError)
        }
        try! RequestManager.send(To: endpoint, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    //MARK: - Account Recovery
    
    func requestRecoveryCodeFor(Key key:String,By by:CodeTransport,completion:@escaping(_ success:Bool)->Void){
        let transport:Users.Account.Transport = by == .email ? .email : .sms
        let endpoint = Users.Account.requestRecoveryCode(key: key, by: transport)
        let onSuccess = Response.OnSuccess(dataType: Data.self, jsonType: Any.self) { (response, urlResponse) in
            print(urlResponse?.allHeaderFields ?? "no header fields")
            completion(true)
            NotificationBannerShortcuts.showRequestRecCodeSuccess(For: by)
        }
        let onFailure = Response.OnFailure(dataType: ApiError.self, jsonType: Any.self) { (response, urlResponse, reqError) in
            completion(false)
            self.processOnFailure(apiError: response.data, reqError: reqError)
        }
        try! RequestManager.send(To: endpoint, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func recoveryAccount(WithKey key:String,by:CodeTransport,code:String,newPassword:String,completion:@escaping(_ success:Bool)->Void){
        let transport:Users.Account.Transport = by == .email ? .email : .sms
        let endpoint = Users.Account.recoveryAccount(key: key, by: transport, code: code, newPassword: newPassword)
        let onSuccess = Response.OnSuccess(dataType: Data.self, jsonType: Any.self) { (response, urlResponse) in
            completion(true)
        }
        let onFailure = Response.OnFailure(dataType: ApiError.self, jsonType: Any.self) { (response, urlResponse, reqError) in
            completion(false)
            self.processOnFailure(apiError: response.data, reqError: reqError)
        }
        try! RequestManager.send(To: endpoint, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    //MARK: - Account and Profile
    
    func getInfoDataOf(UserWithID id:String,completion:@escaping(_ success:Bool)->Void){
        getAccountOfUser(WithID: id) { (success) in
            if success{
                self.getProfileOfUser(WithID: id, completion: completion)
            }
            else{
                completion(false)
            }
        }
    }
    
    
    private func getAccountOfUser(WithID id:String,completion:((_ success:Bool)->Void)?=nil){
        if UserAuth.isUserLogged(),
            let jwt = UserAuth.getToken(){
            
            let endpoint = Users.Account.getAccount(userID: id, jwt: jwt)
            let onSuccess = Response.OnSuccess(dataType: User.self, jsonType: Any.self) { (response, urlResponse) in
                UserAuth.extractAndSaveUserToken(FromRequestHeaders: urlResponse?.allHeaderFields)
                guard let _ = self.user else{
                    self.user = response.data
                    completion?(true)
                    return
                }
                self.user?.account = response.data?.account
                completion?(true)
            }
            let onFailure = Response.OnFailure(dataType: ApiError.self, jsonType: Any.self) { (response, urlResponse, reqError) in
                completion?(false)
                guard let e = reqError else{
                    return
                }
                NotificationBannerShortcuts.showRequestErrorBanner(subtitle: e.localizedDescription)
            }
            try! RequestManager.send(To: endpoint, onSuccess: onSuccess, onFailure: onFailure)
        }
        else{
            completion?(false)
            
        }
    }
    
    
    
    private func getProfileOfUser(WithID id:String,completion:((_ success:Bool)->Void)?=nil){
        if UserAuth.isUserLogged(),
            let _ = UserAuth.getToken(){
            
            let endpoint = Users.Profile.getProfile(userID: id)
            let onSuccess = Response.OnSuccess(dataType: User.self, jsonType: Any.self) { (response, urlResponse) in
                UserAuth.extractAndSaveUserToken(FromRequestHeaders: urlResponse?.allHeaderFields)
                guard let _ = self.user else{
                    self.user = response.data
                    completion?(true)
                    return
                }
                self.user?.profile = response.data?.profile
                completion?(true)
            }
            let onFailure = Response.OnFailure(dataType: ApiError.self, jsonType: Any.self) { (response, urlResponse, reqError) in
                completion?(false)
                guard let e = reqError else{
                    return
                }
                NotificationBannerShortcuts.showRequestErrorBanner(subtitle: e.localizedDescription)
            }
            try! RequestManager.send(To: endpoint, onSuccess: onSuccess, onFailure: onFailure)
        }
        else{
            completion?(false)
            
        }
    }
    
    
    //MARK: - Account and Profile Changes
    
    func updatePassword(Current current:String, New new:String,completion:@escaping(_ success:Bool)->Void){
        
        if let id = user?._id, let jwt = UserAuth.getToken(){
            let endpoint = Users.Account.updatePassword(userID: id, current: current, newPassword: new, jwt: jwt)
            let onSuccess = Response.OnSuccess(dataType: User.self, jsonType: Any.self) { (response, urlResponse) in
                UserAuth.extractAndSaveUserToken(FromRequestHeaders: urlResponse?.allHeaderFields)
                completion(true)
            }
            let onFailure = Response.OnFailure(dataType: ApiError.self, jsonType: Any.self) { (response, urlResponse, reqError) in
                completion(false)
                self.processOnFailure(apiError: response.data, reqError: reqError)
            }
            
            try! RequestManager.send(To: endpoint, onSuccess: onSuccess, onFailure: onFailure)
        }
        else{
            completion(false)
        }
    }
    
    func updateName(name:String,completion:((_ success:Bool)->Void)?=nil){
        if name.isEmpty{
            NotificationBannerShortcuts.showErrBanner(title: "Update Name Failure", subtitle: "Your name can not be blank.")
            return
        }
        
        if let id = user?._id, let jwt = UserAuth.getToken(){
            let endpoint = Users.Account.updateName(userID: id, name: name, jwt: jwt)
            let onSuccess = Response.OnSuccess(dataType: User.self, jsonType: [String:Any].self) { (response, urlResponse) in
                if let account = response.data?.account{
                    self.user?.account = account
                }
                completion?(true)
            }
            let onFailure = Response.OnFailure(dataType: ApiError.self, jsonType: Any.self) { (response, urlResponse, reqError) in
                self.processOnFailure(apiError: response.data, reqError: reqError)
            }
            try! RequestManager.send(To: endpoint, onSuccess: onSuccess, onFailure: onFailure)
        }
        else{
            completion?(false)
            NotificationBannerShortcuts.showErrBanner(title: "Update Name Failure", subtitle: "It was not possible to update your name.")
        }
    }
}
