//
//  LoginVC.swift
//  NuiOS
//
//  Created by Nucleus on 11/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

protocol LoginVCViewModel{
    func performLogin(Username user:String,Password password:String,completion:@escaping(_ success:Bool)->Void)
}

class LoginVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var usernameTF: LinedTTextField!
    @IBOutlet weak var passwordTF: LinedTTextField!
    
    
    @IBOutlet weak var loginButton: NuButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var credentialsView: UIView!
    
    @IBOutlet weak var dist: NSLayoutConstraint!
    private var defaultDist:CGFloat = 0

    var viewModel:LoginVCViewModel?
    
    var hasUsername:Bool{
        return !(usernameTF.text?.isEmpty ?? true)
    }
    
    var hasPassword:Bool{
        return !(passwordTF.text?.isEmpty ?? true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultDist = dist.constant
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startListeningKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopListeningKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func performLoginSegue(){
        
    }
    
    //MARK: - Methods
    func performLogin(){
        self.view.endEditing(true)
        if let username = usernameTF.text, let password = passwordTF.text,
            !username.isEmpty, !password.isEmpty{
            viewModel?.performLogin(Username: username, Password: password, completion: { (success) in
                DispatchQueue.main.async {
                    if success{
                        self.performLoginSegue()
                    }
                }
            })
        }
        else{
            print("show some error banner")
        }
    }
    
    private func activeNormalAppearance(animated:Bool){
        if animated{
            UIView.animate(withDuration: 0.5, delay: 0.3, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.logoImageView.alpha = 1
            }) { (finished) in
            }
        }
        else{
            self.logoImageView.alpha = 1
        }
    }
    
    private func activeUseEmailApperance(animated:Bool,duration:TimeInterval){
        if animated{
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.logoImageView.alpha = 0
            }) { (finished) in
            }
        }
        else{
            self.logoImageView.alpha = 0
        }
    }
    
    //MARK: - IBActions
    @IBAction func loginBtnAction(_ sender: Any) {
        performLogin()
    }
    
    //MARK: - UITextField methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        loginButton.isEnabled = hasUsername && hasPassword
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        loginButton.isEnabled = hasUsername && hasPassword
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == passwordTF.tag {
            performLogin()
        }
        else{
            passwordTF.becomeFirstResponder()
        }
        return true
    }
}

//MARK: - Keyboard listen

extension LoginVC{
    override func keyboardWillAppear(keyboardInfo: [String : Any]) {
        super.keyboardWillAppear(keyboardInfo: keyboardInfo)
        
        let keyBoardFrame = keyboardInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let animationDuration = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey]
        
        
        activeUseEmailApperance(animated: true,duration: animationDuration as! TimeInterval)
        let bottomPos = credentialsView.frame.origin.y+credentialsView.frame.height
        
        if keyBoardFrame.origin.y < bottomPos {
            let moveBy = bottomPos - keyBoardFrame.origin.y
            self.dist.constant -= moveBy
            UIView.animate(withDuration: animationDuration as! TimeInterval, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (finished) in
                
            })
        }
        
    }
    
    override func keyboardWillDisappear(keyboardInfo: [String : Any]) {
        super.keyboardWillDisappear(keyboardInfo: keyboardInfo)
        let animationDuration = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey]
        
        self.activeNormalAppearance(animated: true)
        self.dist.constant = defaultDist
        UIView.animate(withDuration: animationDuration as! TimeInterval, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            
        })
    }
}
