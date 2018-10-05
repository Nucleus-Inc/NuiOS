//
//  AccountRecCodeSVC.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

class AccountRecCodeSVC: SignUpCodeSVC {
    var byType:CodeTransport = .sms

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        codeDelegate = AccountRecCodeDelegate()
        codeDelegate.answers = delegate.answers
        delegate = codeDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        codeDelegate = AccountRecCodeDelegate()
        codeDelegate.answers = delegate.answers
        delegate = codeDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadingMode(Loading loading: Bool) {
        super.loadingMode(Loading: loading)
        if loading{
            nextStepButton.showActivityIndicator(style: .gray)
        }
        else{
            nextStepButton.hideActivityIndicator()
        }
    }
    
    override func codeNotReceivedAction(_ sender: UIButton) {
        self.loadingMode(Loading: true)
        let key:String = byType == .email ? self.delegate.answers!["email"] as! String : self.delegate.answers!["phoneNumber"] as! String
        let alertC = UIAlertController(title: "sending", message: nil, preferredStyle: .alert)
        self.present(alertC, animated: true, completion: nil)
        AppSingleton.shared.requestRecoveryCodeFor(Key: key, By: byType) { (success) in
            alertC.dismiss(animated: true, completion: {
                DispatchQueue.main.async {
                    self.loadingMode(Loading: false)
                }
            })
        }
    }
    
    public func validateCodeLocally() -> Bool {
        if let text = typedCode(){
            return text.count == 4 && !lastInvalidCodes.contains(text)
        }
        return false
    }
    
    override func setUpQuestionInfoLabel() {
        if byType == .sms{
            super.setUpQuestionInfoLabel()
        }
        else{
            let email = (self.delegate.answers!["email"] as! String)
            questionInfoLabel.text = String(format: "email_sent_to_%@".localized, email)
        }
    }
    
    override func didTapNextStepButton(button: UIButton) {
        if validateCodeLocally(),let typedCode = self.typedCode(){
            self.delegate.addStepAnswer(answer: typedCode, forKey: "code")
            self.goToNextStep()
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let id = segue.identifier{
            if id == "nextStep"{
                let vc = segue.destination as? AccountRecPasswordSVC
                vc?.recByType = byType
            }
        }
    }

}

class AccountRecCodeDelegate:SignUpCodeDelegate{
    
    required init() {
        super.init()
    }
    
    override func updateAppearanceOf(NextStepButton button: UIButton) {
        button.setTitle("Next", for: .normal)
    }
}

