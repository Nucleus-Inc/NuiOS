//
//  ExampleSignUpCheckDataStepC.swift
//
//  Created by Nucleus on 24/07/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit
import NuSignUp

public class NuSignUpCheckDataStepC:SignUpCheckDataStepC{
    public var canEdit: Bool = true
    
    public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    public func didTapNextStep(_ delegate: SignUpStepDelegate, onVC vc: UIViewController, completion: @escaping (Bool, [String : Any]?) -> ()) {
        if canEdit{
            AppSingleton.shared.signupUser(Params: delegate.answers ?? [:]) { (success) in
                self.canEdit = !success
                completion(success,[:])
            }
        }
        else{
            canEdit = false
            completion(true,[:])
        }
    }
    
    public func numberOfSections(Delegate delegate: SignUpStepDelegate) -> Int {
        return 1
    }

    public func numberOfRows(Delegate delegate: SignUpStepDelegate, Section section: Int) -> Int {
        return delegate.answers?.keysArray().count ?? 0
    }
    public func dataFor(Delegate delegate: SignUpStepDelegate, AtIndexPath indexPath: IndexPath) -> (key: String, value: String?) {
        //let section = indexPath.section
        let row = indexPath.row
        
        switch row {
        case 0:
            let name = delegate.answer(ForKey: "displayName") as? String
            return ("name".localized,name)
        case 1:
            let phoneNumber = delegate.answer(ForKey: "phoneNumber") as! String
            let maskedNumber = PhoneNumber.BR.mask(text: phoneNumber)
            return ("phoneNumber".localized,maskedNumber)
        case 2:
            return ("email".localized,delegate.answer(ForKey: "email") as? String)
        case 3:
            return ("password".localized,delegate.answer(ForKey: "password") as? String)
        default:
            return ("Extra",nil)
            
        }
    }
    public func titleForHeader(Delegate delegate: SignUpStepDelegate, InSection section: Int) -> String? {
        return "account".localized
    }
    
    public func didSelectAnswerAt(IndexPath indexPath: IndexPath, onVC vc: UIViewController, Delegate delegate: SignUpStepDelegate) {
        let answers = delegate.answers ?? [:]
        switch indexPath.row {
        case 0:
            vc.performSegue(withIdentifier: "reviewName", sender: answers)
        case 1:
            vc.performSegue(withIdentifier: "reviewPhoneNumber", sender: answers)
        case 2:
            vc.performSegue(withIdentifier: "reviewEmail", sender: answers)
        case 3:
            vc.performSegue(withIdentifier: "reviewPassword", sender: answers)
        default:
            break
        }
    }

}
