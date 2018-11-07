//
//  ExtendedLaunchScreenVC.swift
//  NuiOS
//
//  Created by Nucleus on 11/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

private struct ExtendedLaunchScreenVCSeguesIDs{
    static let loginSilently = "loginSilently"
    static let login = "login"
    static let intro = "intro"
    static let accountActivation = "accountActivation"
}

class ExtendedLaunchScreenVC: UIViewController, Listener{
    var myListeners: [NSObjectProtocol] = []
    private var needCheck:Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpListeners()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppSingleton.shared.showIntro(){
            //self.performSegue(withIdentifier: ExtendedLaunchScreenVCSeguesIDs.intro, sender: nil)
            showLogin()
            AppSingleton.shared.setShowIntro(false)
        }
        else if needCheck{
            checkforLoggedUser()
        }
        needCheck = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func checkforLoggedUser(){
        AppSingleton.shared.loginSilently { (success,loggedBy) in
            if let by = loggedBy{
                guard by != .google else{
                    //if by google wait for loginSilently
                    return
                }
            }
            self.continueWith(Success: success,by: loggedBy ?? .local)
        }
    }
    
    private func continueWith(Success success:Bool,by:LoggedBy){
        DispatchQueue.main.async {
            self.rmListeners()
            guard success, let user = AppSingleton.shared.user, let account = user.account else{
                self.showLogin()
                return
            }
            
            if account.local.isActive || by != .local{
                self.performSegue(withIdentifier: ExtendedLaunchScreenVCSeguesIDs.loginSilently, sender: nil)
            }
            else{
                //account activation process
                self.showAccountActivationVC()
            }
        }
    }
    
    //MARK: - Listeners
    
    func setUpListeners() {
        addListener(ForName: AppNotifications.signedInByGoogle) { (weakSelf, notif) in
            if let success = notif.userInfo?["success"] as? Bool{
                self.continueWith(Success: success,by: .google)
            }
            else{
                self.continueWith(Success: false,by: .google)
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier{
            if id == ExtendedLaunchScreenVCSeguesIDs.accountActivation{
                let vc = (segue.destination as? SignUpNavController)?.viewControllers.first as? AlternativeSignUpCodeSVC
                vc?.delegate.answers = sender as? [String:Any]
                vc?.cancelAction = {
                    stepVC,_ in
                    stepVC.dismiss(animated: true, completion: {
                        self.showLogin()
                    })
                }
            }
        }
    }
    
    func showAccountActivationVC(){
        if let user = AppSingleton.shared.user, let json = user.account?.local.toJSON(){
            needCheck = false
            self.performSegue(withIdentifier: ExtendedLaunchScreenVCSeguesIDs.accountActivation, sender: json)
        }
        else{
            showLogin()
        }
    }
    
    func showLogin(){
        AppSingleton.shared.logout()
        self.performSegue(withIdentifier: ExtendedLaunchScreenVCSeguesIDs.login, sender: nil)
    }
}
