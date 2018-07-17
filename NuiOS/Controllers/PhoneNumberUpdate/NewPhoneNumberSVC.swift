//
//  NewPhoneNumberSVC.swift
//  NuiOS
//
//  Created by Nucleus on 17/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit
import NuSignUp

class NewPhoneNumberSVC: SignUpPhoneNumberSVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let id = segue.identifier{
            if id == "nextStep"{
                let vc = segue.destination as? ConfirmationCodeSVC
                vc?.viewModel = ConfirmCodeVM(codeTransport: .sms, key: self.unmaskedAnswer ?? "")
            }
        }
    }
    
}
