//
//  AlternativeSignUpCodeSVC.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

class AlternativeSignUpCodeSVC: SignUpCodeSVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let unmaskedNumber = self.delegate.answers!["phoneNumber"] as? String, !unmaskedNumber.isEmpty{
            sendCodeAgain(By: .sms)
        }
        else if let email = self.delegate.answers!["email"] as? String, !email.isEmpty{
            sendCodeAgain(By: .email)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
