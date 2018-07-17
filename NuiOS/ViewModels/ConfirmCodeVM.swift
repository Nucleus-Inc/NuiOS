//
//  ConfirmCodeVM.swift
//  NuiOS
//
//  Created by Nucleus on 17/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation


class ConfirmCodeVM:ConfirmCodeViewModel{
    var codeTransport: CodeTransport
    var key: String
    
    init(codeTransport:CodeTransport,key:String) {
        self.codeTransport = codeTransport
        self.key = key
    }
    
    func requestCodeAgain(completion: @escaping (Bool) -> Void) {
        if codeTransport == .sms{
            AppSingleton.shared.requestNumberUpdate(NewPhoneNumber: key,completion: completion)
        }
        else{
            AppSingleton.shared.requestEmailUpdate(NewEmail: key, completion: completion)
        }
    }
    
    func confirmUpdate(WithCode code: String, completion: @escaping (Bool) -> Void) {
        if codeTransport == .sms{
            AppSingleton.shared.confirmNumberUpdate(Token: code, completion: completion)
        }
        else{
            AppSingleton.shared.confirmEmailUpdate(Token: code, completion: completion)
        }
    }
}
