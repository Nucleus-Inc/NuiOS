//
//  AccountRecPasswordSVC.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

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
                    UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "Recovery Code", Message: "The recovery code is not valid.")
                    return
                }
                
                if let keyValue = answers[key] as? String{
                    let alertC = UIAlertController(title: "Updating", message: nil, preferredStyle: .alert)
                    self.present(alertC, animated: true, completion: nil)
                    AppSingleton.shared.recoveryAccount(WithKey: keyValue, by: recByType, code: code, newPassword: password) { (success) in
                        DispatchQueue.main.async {
                            alertC.dismiss(animated: true, completion: {
                                if success{
                                    UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "Recovery Account", Message: "Password updated with success.",OKAction:{(_) in
                                        self.navigationController?.dismiss(animated: true, completion: nil)
                                    })
                                }
                            })
                        }
                    }
                }
                else{
                    UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "Recovery Account", Message: "It was not possible to update your password.")
                }
            
            }
        }
        else{
            UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "New Password", Message: "Password and Confirmation values are not the same")
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
