//
//  FirstStepSVC.swift
//  NuSignUp_Example
//
//  Created by Nucleus on 30/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import NuSignUp

class FirstStepSVC: SignUpNameSVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackBtn()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpBackBtn(){
        if stepNumber <= 1 && delegate.reviewMode == .none{
            let closeAllBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(FirstStepSVC.closeAllBtnAction(sender:)))
            self.navigationItem.leftBarButtonItem = closeAllBtn
        }
    }
    
    @objc
    private func closeAllBtnAction(sender:Any){
        
        UIAlertControllerShorcuts.showYesNoAlert(OnVC: self, Title: "cancel_signup".localized, Message: "lose_signup_info_continue?".localized, YesAction: { (_) in
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: {
                SignUpStack.config.finishSignUp()
            })
        })
        
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
