//
//  AccountRecPasswordSVC.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit
import NuSignUp

class AccountRecPasswordSVC: SignUpPasswordSVC {
    
    var recByType:CodeTransport = .sms
    var newPassword:String?{
        return self.answerTF.text
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func didTapNextStepButton(button: UIButton) {
        
        
        if checkEquality(), let password = newPassword{
            let key = recByType == .email ? "email" : "phoneNumber"
            
            if let answers = self.delegate.answers{
                
                guard  let code = answers["code"] as? String else{
                    UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "recovery_code".localized, Message: "recovery_code_invalid".localized)
                    return
                }
                
                if let keyValue = answers[key] as? String{
                    let alertC = UIAlertController(title: "updating".localized, message: nil, preferredStyle: .alert)
                    self.present(alertC, animated: true, completion: nil)
                    AppSingleton.shared.recoveryAccount(WithKey: keyValue, by: recByType, code: code, newPassword: password) { (success) in
                        DispatchQueue.main.async {
                            alertC.dismiss(animated: true, completion: {
                                if success{
                                    UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "recovery_account".localized, Message: "password_update_success".localized,OKAction:{(_) in
                                        self.view.endEditing(true)
                                        self.navigationController?.dismiss(animated: true, completion: {
                                            SignUpStack.config.finishSignUp()
                                        })
                                    })
                                }
                            })
                        }
                    }
                }
                else{
                    UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "recovery_account".localized, Message: "password_update_fail".localized)
                }
            
            }
        }
        else{
            UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "recovery_account".localized, Message: "password_and_confirmation_diferent".localized)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
