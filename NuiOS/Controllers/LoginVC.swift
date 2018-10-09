//
//  LoginVC.swift
//  NuiOS
//
//  Created by Nucleus on 11/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

protocol LoginVCViewModel{
    func performLogin(Username user:String,Password password:String,completion:@escaping(_ success:Bool)->Void)
}

private struct LoginVCSeguesIDs{
    static let login = "login"
    static let accountActivation = "accountActivation"
}

class LoginVC: UIViewController,UITextFieldDelegate,Listener,GIDSignInUIDelegate {
    var myListeners: [NSObjectProtocol] = []
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
        viewModel = AppLoginVM()
        super.viewDidLoad()
        setUpListeners()
        defaultDist = dist.constant
        self.hideKeyboardWhenTappedAround()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
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
    
    deinit {
        rmListeners()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier{
            if id == LoginVCSeguesIDs.accountActivation{
                let vc = (segue.destination as? SignUpNavController)?.viewControllers.first as? AlternativeSignUpCodeSVC
                vc?.delegate.answers = sender as? [String:Any]
            }
        }
    }
    
    func showAccountActivationVC(){
        if let user = AppSingleton.shared.user, let json = user.account?.local.toJSON(){
            self.performSegue(withIdentifier: LoginVCSeguesIDs.accountActivation, sender: json)
        }
    }

    
    func performLoginSegue(){
        if let user = AppSingleton.shared.user, let account = user.account{
            if account.local.isActive{
                self.performSegue(withIdentifier: LoginVCSeguesIDs.login, sender: nil)
            }
            else{
                showAccountActivationVC()
            }
        }
    }
    
    //MARK: - Listeners
    
    func setUpListeners() {
        addListener(ForName: AppNotifications.signedInByGoogle) { (weakSelf, notif) in
            weakSelf.hideSocialNetworkLoginAlert{
                if let success = notif.userInfo?["success"] as? Bool{
                    if success{
                        //activate account not working so perform login imediatelly
                        //self.performSegue(withIdentifier: LoginVCSeguesIDs.login, sender: nil)
                        self.performLoginSegue()
                    }
                }
            }
        }
    }
    
    //MARK: - Methods
    func performLocalLogin(){
        self.view.endEditing(true)
        if let username = usernameTF.text, let password = passwordTF.text,
            !username.isEmpty, !password.isEmpty{
            loginButton.showActivityIndicator(style: .gray)
            viewModel?.performLogin(Username: username, Password: password, completion: { (success) in
                DispatchQueue.main.async {
                    self.loginButton.hideActivityIndicator()
                    if success{
                        self.performLoginSegue()
                    }
                }
            })
        }
        else{
            print("show some error banner")
            NotificationBannerShortcuts.showLoginErrBanner()
        }
    }
    
    func performFacebookLogin(){
        func completion(success:Bool){
            DispatchQueue.main.async {
                self.hideSocialNetworkLoginAlert{
                    if success{
                        self.performLoginSegue()
                    }
                    else{
                        FBSDKLoginManager().logOut()
                    }
                }
            }
        }
        
        AppDelegate.Facebook.login(OnVC: self) { (success) in
            if success, let token = FBSDKAccessToken.current(), let tokenString = token.tokenString{
                AppSingleton.shared.facebookSignIn(idToken: tokenString, completion: { (success) in
                    completion(success: success)
                })
            }
            else{
                completion(success: false)
            }
        }
        
    }
    
    //MARK: - ActivityIndicatorAlertVC methods
    
    func showSocialNetworkLoginAlert(completion:(()->Void)?){
        let alert = ActivityIndicatorAlertVC()
        self.present(alert, animated: true, completion: completion)
    }
    
    func hideSocialNetworkLoginAlert(completion:(()->Void)?=nil){
        
        if let alert = self.presentedViewController as? ActivityIndicatorAlertVC{
            alert.dismiss(animated: true, completion: completion)
        }
    }
    
    //MARK: - IBActions
    @IBAction func loginBtnAction(_ sender: Any) {
        AppSingleton.shared.logout()
        performLocalLogin()
    }
    
    @IBAction func googleLoginBtnAction(_ sender: Any) {
        AppSingleton.shared.logout()
        showSocialNetworkLoginAlert {
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    @IBAction func facebookLoginBtnAction(_ sender: Any) {
        AppSingleton.shared.logout()
        showSocialNetworkLoginAlert{
            self.performFacebookLogin()
        }
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
            performLocalLogin()
        }
        else{
            passwordTF.becomeFirstResponder()
        }
        return true
    }
}

//MARK: - Keyboard listen

extension LoginVC{
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
