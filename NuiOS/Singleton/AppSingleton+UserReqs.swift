//
//  AppSingleton+UserReqs.swift
//  NuiOS
//
//  Created by Nucleus on 12/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation

//MARK: - Account
extension AppSingleton{
    
    //MARK: - SignUp
    func signupUser(Params params:[String:Any],completion:@escaping(_ success:Bool)->Void){
        let endpoint = Users.Account.signup(params: params)
        let onSuccess = Response.OnSuccess(dataType: User.self, jsonType: [String:Any].self) { (response, urlResponse) in
            self.user = response.data
            completion(true)
        }
        let onFailure = Response.OnFailure(dataType: ApiError.self, jsonType: Any.self) { (response, urlResponse, reqError) in
            completion(false)
        }
        
        try! RequestManager.send(To: endpoint, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    

    
}
