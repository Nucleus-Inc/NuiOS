//
//  AppDelegate+FacebookLogin.swift
//  NuiOS
//
//  Created by Nucleus on 09/10/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation
import FBSDKLoginKit

extension AppDelegate{
    
    class Facebook{
        class func setUp(){
            //set up listeners
        }
        
        class func login(OnVC vc:UIViewController,completion:((_ success:Bool)->Void)?=nil){
            
            let login = FBSDKLoginManager()
            
            login.logIn(withReadPermissions: ["public_profile","email"], from: vc) { (result, error) in
                guard let _ = error else{
                    guard let result = result else{
                        completion?(false)
                        return
                    }
                    if result.isCancelled{
                        completion?(false)
                    }
                    else{
                        completion?(true)
                    }
                    return
                }
                completion?(false)
            }
        }
        
    }
    
}
