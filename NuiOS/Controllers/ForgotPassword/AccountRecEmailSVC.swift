//
//  AccountRecEmailSVC.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

class AccountRecEmailSVC: SignUpEmailSVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didTapNextStepButton(button: UIButton) {
        if let email = self.stepAnswer{
            loadingMode(Loading: true)
            self.answerTF.resignFirstResponder()
            showValidationActivity()
            AppSingleton.shared.requestRecoveryCodeFor(Key: email, By: .email) { (success) in
                DispatchQueue.main.async {
                    self.hideValidationActivity()
                    self.loadingMode(Loading: false)
                    if success{
                        self.delegate.addStepAnswer(answer: email, forKey: self.key)
                        self.goToNextStep()
                    }
                    else{
                        self.answerTF.becomeFirstResponder()
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let id = segue.identifier{
            if id == "nextStep"{
                let vc = segue.destination as? AccountRecCodeSVC
                vc?.byType = .email
            }
        }
    }

}
