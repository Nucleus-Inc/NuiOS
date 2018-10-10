//
//  SignUpCodeSVC.swift
//
//  Created by José Lucas Souza das Chagas on 07/06/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit
//import InputMask
import NuSignUp

enum CodeTransport:String{
    case sms = "sms"
    case email = "email"
}

class SignUpCodeSVC: SignUpStepVC,UITextFieldDelegate/*MaskedTextFieldDelegateListener*/ {
    
    @IBOutlet weak var sendAgainButton: UIButton!

    @IBOutlet weak var questionInfoLabel: UILabel!
    
    @IBOutlet var codeTFs: [UITextField]!
    
    @IBOutlet weak var answerInfoTF: InfoLabel!
    
    private var defaultMessage:String?
    
    @IBInspectable var minCharacters:Int = 0
    
    var defaultTransport:CodeTransport = .email
    
    //private var maskDelegate:MaskedTextFieldDelegate?
    var lastInvalidCodes:[String] = []

    var codeDelegate:SignUpCodeDelegate = SignUpCodeDelegate()
        
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUpDelegate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpDelegate()
    }
    
    func setUpDelegate(){
        codeDelegate.answers = delegate.answers
        self.delegate = codeDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultMessage = answerInfoTF.text
        setUpTextField()
        setUpQuestionInfoLabel()
        self.didChangeStepAnswers()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        codeTFs[0].becomeFirstResponder()
        delegate.updateAppearanceOf(NextStepButton: nextStepButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate.reviewMode = .none
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
    
    //MARK: - CodeSVC
    
    private func clearCode(){
        for codeTF in codeTFs{
            codeTF.text = nil
        }
    }
    
    func typedCode()->String?{
        var code:String?
        for codeTF in codeTFs{
            if let number = codeTF.text{
                if let c = code{
                    code = c + number
                }
                else{
                    code = number
                }
            }
        }
        return code
    }

    private func updateAnswerInfoMessage(){
        if let code = typedCode(){
            lastInvalidCodes.contains(code) ? showAnswerInfoErrMessage() : showAnswerInfoDefaultMessage()
        }
        else{
            showAnswerInfoDefaultMessage()
        }
    }
    
    private func showAnswerInfoErrMessage(){
        self.answerInfoTF.text = "invalid_code".localized
        self.answerInfoTF.style = .error
    }
    
    private func showAnswerInfoDefaultMessage(){
        self.answerInfoTF.text = defaultMessage
        self.answerInfoTF.style = .normal
    }

    
    @IBAction func codeNotReceivedAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let alertC = UIAlertController(title: "account_activation".localized, message: "send_code_again".localized, preferredStyle: .actionSheet)
        
        if let unmaskedNumber = self.delegate.answers!["phoneNumber"] as? String, !unmaskedNumber.isEmpty{
            let toNumberStr = String(format: "sms-%@".localized, unmaskedNumber)
            let toNumber = UIAlertAction(title: toNumberStr, style: .default) { (_) in
                self.sendCodeAgain(By:.sms)
            }
            alertC.addAction(toNumber)
        }
        
        if let email = self.delegate.answers!["email"] as? String, !email.isEmpty{
            let toEmailStr = String(format: "email-%@".localized, email)
            let toEmail = UIAlertAction(title: toEmailStr, style: .default) { (_) in
                self.sendCodeAgain(By:.email)
            }
            alertC.addAction(toEmail)
        }

        let cancel = UIAlertAction(title: "cancel".localized, style: .cancel) { (_) in}
        alertC.addAction(cancel)
        
        if let popoverController = alertC.popoverPresentationController {// IPAD
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        self.present(alertC, animated: true, completion: nil)
        
    }
    
    //MARK: - Server methods
    override func loadingMode(Loading loading: Bool) {
        super.loadingMode(Loading: loading)
        sendAgainButton.isEnabled = !loading
        for tfs in codeTFs{
            tfs.isEnabled = !loading
        }
    }

    internal func sendCodeAgain(By by:CodeTransport = .sms){
        print("Method to request code again")
        if let id = AppSingleton.shared.user?._id{
            AppSingleton.shared.reqActivationCode(ForUserID: id, By: by)
        }
    }
    
    /**
     This method tries to validate the current account with typed code
     */
    private func validateAccount(){
        if let id = AppSingleton.shared.user?._id, let code = typedCode(){
            let alert = UIAlertController(title: "validating".localized, message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            self.loadingMode(Loading: true)

            AppSingleton.shared.activateAccount(OfUserID: id, WithCode: code) { (success, validCode) in
                DispatchQueue.main.async {
                    self.codeDelegate.isServerSideValid = validCode
                    alert.dismiss(animated: true, completion: {
                        
                        self.loadingMode(Loading: false)
                        
                        if success && validCode{
                            UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "account_activation".localized, Message: "account_activation_success".localized, OKAction: { (_) in
                                self.goToNextStep()
                            })
                        }
                        else{
                            if !validCode{
                                self.lastInvalidCodes.append(self.typedCode()!)
                                self.clearCode()
                            }
                            else{
                                //UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "Error", Message: "It was not possible to validate your account.")
                            }
                        }
                        
                        self.updateAnswerInfoMessage()
                        
                    })
                    
                }
            }
        }

    }
    
    

    //MARK: - SignUpStepController methods
    
    override func didChangeStepAnswers() {
        super.didChangeStepAnswers()
        codeDelegate.isServerSideValid = false
        delegate.updateAppearanceOf(NextStepButton: nextStepButton)
        updateAnswerInfoMessage()
    }
    
    override func shouldPresentNextStepButton() -> Bool {
        if let text = typedCode(){
            return text.count == minCharacters && !lastInvalidCodes.contains(text)
        }
        return false
    }
    
    override func didTapNextStepButton(button: UIButton) {
        super.didTapNextStepButton(button: button)
        print("Add answer on answers")
        
        if !codeDelegate.isServerSideValid,  let text = typedCode() {
            if !lastInvalidCodes.contains(text){
                
                validateAccount()
                
            }
            else{
                
                UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "typed_code_invalid".localized, Message: "ask_new_code".localized,OKAction:{(_) in
                    self.codeTFs[0].becomeFirstResponder()
                    self.clearCode()
                })
            }
        }
        else{
            goToNextStep()
        }
    }

    //MARK: - UILabel methods
    
    internal func setUpQuestionInfoLabel(){
        questionInfoLabel.text = ""
        if defaultTransport == .email{
            if let email = self.delegate.answers!["email"] as? String, !email.isEmpty{
                questionInfoLabel.text = String(format: "email_sent_to_%@".localized, email)
            }
        }
        else{
            if let number = self.delegate.answers!["phoneNumber"] as? String, !number.isEmpty{
                let maskedNumber = PhoneNumber.BR.mask(number: number)
                questionInfoLabel.text = String(format: "sms_sent_to_%@".localized, maskedNumber)
            }
        }
    }

    //MARK: - UITextField methods
    private func setUpTextField(){
        //maskDelegate = MaskedTextFieldDelegate(format: "[0]")
        //maskDelegate?.autocomplete = false
        //maskDelegate?.listener = self
        
        for codeTF in codeTFs{
            codeTF.delegate = self//maskDelegate
        }
    }
    
    @IBAction func didChangeText(_ sender: Any) {
        self.didChangeStepAnswers()
    }
    
    func addStringOnTF(AtPosition pos:Int,String s:String){
        guard let text = codeTFs[pos].text, !text.isEmpty else{
            codeTFs[pos].text = s
            return
        }
    }
    
    //MARK: - MaskedTextFieldDelegateListener methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //didChangeStepAnswers()

        if string == ""{
            let pos = textField.tag
            let newPos = pos - 1
            textField.text = nil
            if newPos >= 0 {
                codeTFs[newPos].becomeFirstResponder()
            }
            //maskDelegate?.put(text: string, into: textField)
        }
        else{
            if let text = textField.text, !text.isEmpty{
                let pos = textField.tag
                let newPos = pos + 1
                if newPos < 4{
                    //maskDelegate?.put(text: string, into: codeTFs[newPos])
                    addStringOnTF(AtPosition: newPos, String: string)
                    codeTFs[newPos].becomeFirstResponder()
                }
            }
            else{
                textField.text = string
                //maskDelegate?.put(text: string, into: textField)
            }
            
        }
        didChangeStepAnswers()
        return false
    }
    
    /*InputMask
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        didChangeStepAnswers()
    }
     */
}

/**
 Override from the same class of 'SignUpConfig.baseStepsDelegate'
 */
class SignUpCodeDelegate:AppSignUpDelegate{
    
    var isServerSideValid:Bool = false
    
    required init() {
        super.init()
    }
    
    override func updateAppearanceOf(NextStepButton button: UIButton) {
        let title = (isServerSideValid ? "next" : "validate").localized
        button.setTitle(title, for: .normal)
    }
}
