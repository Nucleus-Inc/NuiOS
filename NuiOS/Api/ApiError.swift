//
//  ApiError.swift
//  MeaStartIntegration
//
//  Created by Nucleus on 09/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation

typealias ResponseCode = String

struct ApiError:Decodable{
    //var httpCode:Int
    //var response: Response
    var errorCode:ResponseCode
    var description:String
    var localizedDescription:String{
        return NSLocalizedString(errorCode, tableName: "APIErrorLocalizable", bundle: .main, comment: "")
    }
    
    struct Code{
        static let REQ001:ResponseCode = "REQ-001"
        static let REQ002:ResponseCode = "REQ-002"
        static let REQ003:ResponseCode = "REQ-003"
        
        static let AUT001:ResponseCode = "AUT-001"
        static let AUT002:ResponseCode = "AUT-002"
        static let AUT003:ResponseCode = "AUT-003"
        static let AUT004:ResponseCode = "AUT-004"
        static let AUT005:ResponseCode = "AUT-005"
        static let AUT006:ResponseCode = "AUT-006"
        
        static let SRV001:ResponseCode = "SRV-001"
    }

    /*
    enum Code:String,Codable{
        case REQ001 = "REQ-001"
        case REQ002 = "REQ-002"
        case REQ003 = "REQ-003"
        
        case AUT001 = "AUT-001"
        case AUT002 = "AUT-002"
        case AUT003 = "AUT-003"
        case AUT004 = "AUT-004"
        case AUT005 = "AUT-005"
        case AUT006 = "AUT-006"
        
        case SRV001 = "SRV-001"
    }
     */
    
}
