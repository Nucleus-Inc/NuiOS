//
//  AccountRecPhoneNumberSVC.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

class AccountRecPhoneNumberSVC: SignUpPhoneNumberSVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let id = segue.identifier{
            if id == "nextStep"{
                let vc = segue.destination as? AccountRecCodeSVC
                vc?.defaultTransport = .sms
            }
        }
    }
    
    override func didTapNextStepButton(button: UIButton) {
        if let phoneNumber = self.unmaskedAnswer{
            loadingMode(Loading: true)
            self.showValidationActivity()
            self.answerTF.resignFirstResponder()
            AppSingleton.shared.requestRecoveryCodeFor(Key: phoneNumber, By: .sms) { (success) in
                DispatchQueue.main.async {
                    self.loadingMode(Loading: false)
                    self.hideValidationActivity()
                    if success{
                        self.delegate.addStepAnswer(answer: phoneNumber, forKey: self.key)
                        self.goToNextStep()
                    }
                    else{
                        self.answerTF.becomeFirstResponder()
                    }
                }
            }
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
