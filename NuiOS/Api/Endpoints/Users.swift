//
//  Verifications.swift
//  MeaStartIntegration
//
//  Created by Nucleus on 11/06/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation

enum Users:Endpoint{
    static var title: String = "users"

    case getAll
    case signin(email:String,password:String)
    
    func endpointInfo() throws -> EndpointInfo {

        switch self {
        case .signin(let email,let password):
            let url = Api.Config.buildUrl(Endpoint: Users.title+"/auth/local/jwt/signin")
            return try EndpointInfo(url: url, method: .post,params:["email":email,"password":password])
        case .getAll:
            let url = Api.Config.buildUrl(Endpoint: Users.title)
            return try EndpointInfo(url: url, method: .get)
        }
        
    }
    
    enum Account:Endpoint{

        static var title: String{
            return "account"
        }
        
        case getAccount(userID:String,jwt:String)

        func endpointInfo() throws -> EndpointInfo {
            switch self {
            case .getAccount(let userID,let jwt):
                let url = Api.Config.buildUrl(Endpoint: Users.title+"/"+userID+"/"+Account.title)
                return try EndpointInfo(url: url, method: .get,headers: ["Authorization":"JWT "+jwt])
            }
        }
        
    }
}


extension Users.Account{
    enum Local:Endpoint{
        enum Transport:String{
            case email = "email"
            case sms = "sms"
        }

        static var title: String{
            return Users.Account.title+"/local"
        }
        
        static func signupWith<T:Encodable>(data:T) throws -> Local{
            let data = try JSONEncoder().encode(data)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
            return Local.signup(params: json ?? [:])
        }
        
        case signup(params:[String:Any])
        //case signupWith(data:T)
        case requestActivationCode(userID:String,by:Transport)
        case activateAccount(userID:String,code:String,jwt:String)
        
        case updatePassword(userID:String,current:String,newPassword:String,jwt:String)
        case updateName(userID:String,name:String,jwt:String)
        
        case requestPhoneUpdate(userID:String,phoneNumber:String,jwt:String)
        case confirmPhoneUpdate(userID:String,token:String,jwt:String)
        
        case requestEmailUpdate(userID:String,email:String,jwt:String)
        case confirmEmailUpdate(userID:String,token:String,jwt:String)
        
        case updatePicture(userID:String,pictureUrl:String,jwt:String)
        
        case requestRecoveryCode(key:String,by:Transport)
        case recoveryAccount(key:String,by:Transport,code:String,newPassword:String)
        
        func endpointInfo() throws -> EndpointInfo {
            switch self {
                
            case .updatePassword(let userID,let currentPassword,let newPassword,let jwt):
                let url = Api.Config.buildUrl(Endpoint: Users.title+"/"+userID+"/"+Local.title+"/password")
                return try EndpointInfo(url: url, method: .put, params: ["currentPassword":currentPassword,"newPassword":newPassword], headers: ["Authorization":"JWT "+jwt])
                
            case .updateName(let userID,let name,let jwt):
                let url = Api.Config.buildUrl(Endpoint: Users.title+"/"+userID+"/"+Local.title+"/displayName")
                return try EndpointInfo(url: url, method: .put, params: ["displayName":name], headers: ["Authorization":"JWT "+jwt])
                
            case .confirmPhoneUpdate(let userID,let token,let jwt):
                let url = Api.Config.buildUrl(Endpoint: Users.title+"/"+userID+"/"+Local.title+"/phone-number")
                return try EndpointInfo(url: url, method: .put, params: ["token":token], headers: ["Authorization":"JWT "+jwt])
                
            case .requestPhoneUpdate(let userID,let phoneNumber,let jwt):
                let url = Api.Config.buildUrl(Endpoint: Users.title+"/"+userID+"/"+Local.title+"/phone-number")
                return try EndpointInfo(url: url, method: .patch, params: ["phoneNumber":phoneNumber], headers: ["Authorization":"JWT "+jwt])
                
            case .confirmEmailUpdate(let userID,let token,let jwt):
                let url = Api.Config.buildUrl(Endpoint: Users.title+"/"+userID+"/"+Local.title+"/email")
                return try EndpointInfo(url: url, method: .put, params: ["token":token], headers: ["Authorization":"JWT "+jwt])
                
            case .requestEmailUpdate(let userID,let email,let jwt):
                let url = Api.Config.buildUrl(Endpoint: Users.title+"/"+userID+"/"+Local.title+"/email")
                return try EndpointInfo(url: url, method: .patch, params: ["email":email], headers: ["Authorization":"JWT "+jwt])
                
            case .updatePicture(let userID,let pictureUrl,let jwt):
                let url = Api.Config.buildUrl(Endpoint: Users.title+"/"+userID+"/"+Local.title+"/photo")
                return try EndpointInfo(url: url, method: .put,params:["photo":pictureUrl],headers: ["Authorization":"JWT "+jwt])
                
            case .requestRecoveryCode(let key, let using):
                let url = Api.Config.buildUrl(Endpoint: Users.title+"/"+Local.title+"/recovery?"+"transport="+using.rawValue)
                return try EndpointInfo(url: url, method: .patch, params: ["recoveryKey":key])
                
            case .recoveryAccount(let key, let using,let token,let newPassword):
                let url = Api.Config.buildUrl(Endpoint: Users.title+"/"+Local.title+"/recovery?"+"transport="+using.rawValue)
                return try EndpointInfo(url: url, method: .put, params:  ["recoveryKey":key,"token":token,"newPassword":newPassword])
                
            case .requestActivationCode(let userID,let using):
                let url = Api.Config.buildUrl(Endpoint: Users.title+"/"+userID+"/"+Local.title+"/activation?"+"transport="+using.rawValue)
                return try EndpointInfo(url: url, method: .patch)
                
            case .activateAccount(let userID,let code,let jwt):
                let url = Api.Config.buildUrl(Endpoint: Users.title+"/"+userID+"/"+Local.title+"/activation")
                return try EndpointInfo(url: url, method: .put,params:["token":code],headers: ["Authorization":"JWT "+jwt])
                
            case .signup(let params):
                let url = Api.Config.buildUrl(Endpoint: Users.title+"/"+Local.title+"/signup")
                return try EndpointInfo(url: url, method: .post,params:params)
                
                /*case .signupWith(let data):
                 let url = Api.Config.buildUrl(Endpoint: Users.title+"/"+Local.title+"/signup")
                 return try EndpointInfo(url: url, method: .post, object: data)*/
            }
            
        }
    }
}
