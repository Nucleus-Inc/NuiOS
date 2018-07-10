//
//  Verifications.swift
//  MeaStartIntegration
//
//  Created by Nucleus on 04/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation


enum Verifications:Endpoint{
    static var title: String = "verifications"
    
    case checkStrength(password:String)
    
    enum User:Endpoint{
        static var title:String = "user"
        
        case emailAvailable(email:String)
        case phoneNumberAvailable(phoneNumber:String)

        func endpointInfo() throws -> EndpointInfo {
            switch self {
                
            case .phoneNumberAvailable(let phoneNumber):
                let url = Api.Config.buildUrl(Endpoint: Verifications.title+"/"+User.title+"?phoneNumber="+phoneNumber)
                return try EndpointInfo(url: url, method: .get)
                
            case .emailAvailable(let email):
                let url = Api.Config.buildUrl(Endpoint: Verifications.title+"/"+User.title+"?email="+email)
                return try EndpointInfo(url: url, method: .get)
            }
        }
        
    }
    
    func endpointInfo() throws -> EndpointInfo {
        switch self {
        case .checkStrength(let password):
            let url = Api.Config.buildUrl(Endpoint: Verifications.title+"/password")
            return try EndpointInfo(url: url, method: .post, params: ["password":password])
        }
    }
}
