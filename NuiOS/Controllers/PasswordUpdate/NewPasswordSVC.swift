//
//  NewPasswordSVC.swift
//  NuiOS
//
//  Created by Nucleus on 18/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit
import NuSignUp

class NewPasswordSVC: SignUpPasswordSVC {

    override func viewDidLoad() {
        key = "newPassword"
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updatePassword(){
        let newPass = self.answerTF.text ?? ""
        let currentPass = (delegate.answer(ForKey: "password") as? String) ?? ""
        
        let alert = UIAlertController(title: "updating".localized, message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        self.loadingMode(Loading: true)
        
        AppSingleton.shared.updatePassword(Current: currentPass, New: newPass) { (success) in
            DispatchQueue.main.async {
                self.loadingMode(Loading: false)
                alert.dismiss(animated: true, completion: {
                    if success{
                        UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "password_update".localized, Message: "password_update_success".localized, OKAction: { (_) in
                            self.view.endEditing(true)
                            self.dismiss(animated: true, completion: {
                                SignUpStack.config.finishSignUp()
                            })
                        })
                    }
                })
            }
        }
    }
    
    override func didTapNextStepButton(button: UIButton) {
        
        if checkEquality(){
            updatePassword()
        }
        else{
            super.didTapNextStepButton(button: button)
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
