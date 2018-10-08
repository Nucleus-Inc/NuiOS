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
    static let accountActivation = "accountActivation"
}

class ExtendedLaunchScreenVC: UIViewController, Listener{

    var myListeners: [NSObjectProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpListeners()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkforLoggedUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func checkforLoggedUser(){
        AppSingleton.shared.loginSilently { (success) in
            self.continueWith(Success: success)
        }
    }
    
    private func continueWith(Success success:Bool){
        DispatchQueue.main.async {
            if success{
                if let user = AppSingleton.shared.user, let account = user.account{
                    if account.local.isActive{
                        self.performSegue(withIdentifier: ExtendedLaunchScreenVCSeguesIDs.loginSilently, sender: nil)
                    }
                    else{
                        //account activation process
                        //self.showAccountActivationVC() it is causing some problems when tapping on cancel button
                        self.performSegue(withIdentifier: ExtendedLaunchScreenVCSeguesIDs.login, sender: nil)
                    }
                }
            }
            else{
                self.performSegue(withIdentifier: ExtendedLaunchScreenVCSeguesIDs.login, sender: nil)
            }
            self.rmListeners()
        }
    }
    
    //MARK: - Listeners
    
    func setUpListeners() {
        addListener(ForName: AppNotifications.signedInByGoogle) { (weakSelf, notif) in
            if let success = notif.userInfo?["success"] as? Bool{
                self.continueWith(Success: success)
            }
            else{
                self.continueWith(Success: false)
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
            }
        }
    }
    
    func showAccountActivationVC(){
        if let user = AppSingleton.shared.user, let json = user.account?.toJSON(){
            self.performSegue(withIdentifier: ExtendedLaunchScreenVCSeguesIDs.accountActivation, sender: json)
        }
        else{
            self.performSegue(withIdentifier: ExtendedLaunchScreenVCSeguesIDs.login, sender: nil)
        }
    }
}
