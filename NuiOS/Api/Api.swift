//
//  Protocols.swift
//  MeaStartIntegration
//
//  Created by Nucleus on 11/06/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation

class Api{
    static var serverAddress:String = ""
    
    public class func setUpWith(Address address:String){
        serverAddress = Config.configAddress(address)
    }
    
    class Config{
        fileprivate class func configAddress(_ address:String)->String{
            return address + (address.hasSuffix("/") ? "" : "/")
        }
        
        public class func buildUrl(Endpoint endpoint:String)->String{
            let concatWith = endpoint.hasPrefix("/") ? String(endpoint.suffix(endpoint.count - 1)) : endpoint
            return serverAddress+concatWith
        }
    }
}


