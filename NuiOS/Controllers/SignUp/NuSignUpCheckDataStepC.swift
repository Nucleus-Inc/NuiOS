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
    
    public func didTapNextStep(_ answers:[String : Any], onVC vc: UIViewController, completion: @escaping (Bool,[String:Any]?) -> ()) {
        
        if canEdit{
            AppSingleton.shared.signupUser(Params: answers) { (success) in
                completion(success,[:])
            }
        }
        else{
            completion(true,[:])
        }
        
    }
    
    
    public func numberOfSections(Answers answers: [String : Any]) -> Int {
        return 1
    }
    
    public func numberOfRows(Answers answers: [String : Any], Section section: Int) -> Int {
        return answers.keysArray().count
    }
    
    public func dataFor(Answers answers: [String : Any], AtIndexPath indexPath: IndexPath) -> (key: String, value: String?) {
        //let section = indexPath.section
        let row = indexPath.row
        
        switch row {
        case 0:
            let name = answers["displayName"] as? String
            return ("name".localized,name)
        case 1:
            let phoneNumber = answers["phoneNumber"] as! String
            let maskedNumber = PhoneNumber.BR.mask(number: phoneNumber)
            return ("phoneNumber".localized,maskedNumber)
        case 2:
            return ("email".localized,answers["email"] as? String)
        case 3:
            return ("password".localized,answers["password"] as? String)
        default:
            return ("Extra",nil)

        }
    }
    
    public func titleForHeader(Answers answers: [String : Any], InSection section: Int) -> String? {
        return "account".localized
    }
    
    public func didSelectAnswerAt(IndexPath indexPath: IndexPath, onVC vc: UIViewController, fromAnswers answers: [String : Any]) {
        
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
