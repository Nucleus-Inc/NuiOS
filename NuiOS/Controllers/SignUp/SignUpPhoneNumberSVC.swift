//
//  SignUpPhoneNumberSVC.swift
//
//  Created by Nucleus on 08/06/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit
import NuSignUp

class SignUpPhoneNumberSVC: SignUpNameSVC {
    var maskRegex:String? = PhoneNumber.BR.maskingPattern.regex //"([0-9]{3})([0-9]{3})([0-9]{4})" // USA
    var replacementRole:String? = PhoneNumber.BR.maskingPattern.format //"+1 ($1) $2-$3" //USA

    private var defaultMessage:String?

    private var isServerSideValid:Bool = false
    internal var sendingData:Bool = false
    
    var lastInvalidNumbers:[String] = []
    
    var unmaskedAnswer: String?{
        return self.stepAnswer?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "+", with: "")
    }

    
    override func viewDidLoad() {
        self.regex = "\\+(55)\\ \\([0-9]{2}\\)\\ [0-9]{5}\\-[0-9]{4}" // BR
        
        defaultMessage = answerInfoTF.text
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - PhoneNumberSVC
    private func updateAnswerInfoMessage(){
        lastInvalidNumbers.contains(stepAnswer!) ? showAnswerInfoErrMessage() : showAnswerInfoDefaultMessage()
    }
    
    private func showAnswerInfoErrMessage(){
        self.answerInfoTF.text = "phoneNumber_in_use".localized
        self.answerInfoTF.style = .error
    }
    
    private func showAnswerInfoDefaultMessage(){
        self.answerInfoTF.text = defaultMessage
        self.answerInfoTF.style = .normal
    }
    
    
    override func didChangeText(_ sender: Any) {
        if let maskRegex = maskRegex, let replacement = replacementRole{
            let text = answerTF.text ?? ""
            let newText = text.replacingOccurrences(of: maskRegex, with: replacement, options: [.regularExpression,.anchored], range: nil)
            self.answerTF.text = newText
        }
        super.didChangeText(sender)
    }
    
    
    //MARK: - Server methods
    
    private func validatePhoneNumberOnServer(){
        self.loadingMode(Loading: true)
        
        showValidationActivity()
        
        AppSingleton.shared.checkAvailabilityOf(Key: unmaskedAnswer ?? "", KeyType: .phoneNumber) { (success, isAvailable) in
            DispatchQueue.main.async {
                self.hideValidationActivity()
                self.loadingMode(Loading: false)
                if success{
                    if isAvailable{
                        
                        self.isServerSideValid = true
                        print("Add answer on answers")
                        self.delegate.addStepAnswer(answer: self.unmaskedAnswer!, forKey: self.key)
                        self.goToNextStep()
                        
                    }
                    else{
                        self.answerTF.becomeFirstResponder()
                        self.isServerSideValid = false
                        self.lastInvalidNumbers.append(self.stepAnswer!)
                        self.showAnswerInfoErrMessage()
                        
                        //UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: nil, Message: "This phone number is in use. Try another one.", OKAction: nil)
                    }
                }
                else{
                    self.answerTF.becomeFirstResponder()
                }
            }
        }
    }
    
    
    //MARK: SignUpStepController methods
    
    override func didChangeStepAnswers() {
        super.didChangeStepAnswers()
        self.isServerSideValid = false
        self.updateAnswerInfoMessage()
    }
    
    override func didTapNextStepButton(button: UIButton) {
        
        if !isServerSideValid {

            if let stepAnswer = self.stepAnswer, !lastInvalidNumbers.contains(stepAnswer){
                //testa
                validatePhoneNumberOnServer()
            }
            else{
                self.showAnswerInfoErrMessage()
            }
        }
        else{
            print("Add answer on answers")
            delegate.addStepAnswer(answer: self.unmaskedAnswer!, forKey: self.key)
            goToNextStep()
        }
        
    }
    
    override func shouldPresentNextStepButton() -> Bool {
        if super.shouldPresentNextStepButton(){
            if let text = stepAnswer{
                return !lastInvalidNumbers.contains(text)
            }
        }
        return false
    }


}
