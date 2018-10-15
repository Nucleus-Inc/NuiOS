//
//  ConfirmationCodeSVC.swift
//  NuiOS
//
//  Created by Nucleus on 17/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit
import NuSignUp

protocol ConfirmCodeViewModel{
    var codeTransport:CodeTransport{get}
    var key:String{get}
    
    func requestCodeAgain(completion:@escaping(Bool)->Void)
    func confirmUpdate(WithCode code:String,completion:@escaping(Bool)->Void)
}


class ConfirmationCodeSVC: SignUpCodeSVC {

    var viewModel:ConfirmCodeViewModel?{
        didSet{
            defaultTransport = viewModel?.codeTransport ?? .email
        }
    }
    
    override func setUpDelegate() {
        codeDelegate = ConfirmationCodeDelegate()
        codeDelegate.answers = delegate.answers
        delegate = codeDelegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.requestCodeAgain(completion: { (_) in
            
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func setUpQuestionInfoLabel() {
        if let vm = viewModel{
            if vm.codeTransport == .sms{
                super.setUpQuestionInfoLabel()
            }
            else{
                let email = (self.delegate.answers!["email"] as! String)
                let text = String(format: "email_sent_to_%@".localized, email)
                questionInfoLabel.text = text

            }
        }
    }

    
    override func codeNotReceivedAction(_ sender: UIButton) {
        if let vm = viewModel{
            self.loadingMode(Loading: true)
            let alertC = UIAlertController(title: "sending".localized, message: nil, preferredStyle: .alert)
            self.present(alertC, animated: true, completion: nil)
            
            vm.requestCodeAgain { (success) in
                alertC.dismiss(animated: true, completion: {
                    DispatchQueue.main.async {
                        self.loadingMode(Loading: false)
                        self.codeTFs.first?.becomeFirstResponder()
                    }
                })
            }
        }
    }
    
    override func didTapNextStepButton(button: UIButton) {
        if let vm = viewModel, let code = typedCode(){
            let alert = UIAlertController(title: "confirming_update".localized, message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            self.loadingMode(Loading: true)
            
            vm.confirmUpdate(WithCode: code) { (success) in
                DispatchQueue.main.async {
                    alert.dismiss(animated: true, completion: {
                        
                        self.loadingMode(Loading: false)
                        if success{
                            let title = (vm.codeTransport == .email ? "email_update" : "phone_number_update").localized
                            let message = (vm.codeTransport == .email ? "email_update_success" : "phoneNumber_update_success").localized
                            
                            UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: title, Message: message,OKAction: {
                                (_) in
                                self.dismiss(animated: true, completion: {
                                    SignUpStack.config.finishSignUp()
                                })
                            })
                        }
                        
                    })
                }
            }
        }
        
    }

}


class ConfirmationCodeDelegate:SignUpCodeDelegate{
    required init() {
        super.init()
    }
    override func updateAppearanceOf(NextStepButton button: UIButton) {}
}
