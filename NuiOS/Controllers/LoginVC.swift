//
//  LoginVC.swift
//  NuiOS
//
//  Created by Nucleus on 11/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var credentialsView: UIView!
    
    @IBOutlet weak var dist: NSLayoutConstraint!
    private var defaultDist:CGFloat = 0

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Keyboard listen

extension LoginVC{
    override func keyboardWillAppear(keyboardInfo: [String : Any]) {
        super.keyboardWillAppear(keyboardInfo: keyboardInfo)
        
        let keyBoardFrame = keyboardInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let animationDuration = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey]
        
        //activeUseEmailApperance(animated: true,duration: animationDuration as! TimeInterval)
        
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
        
        //self.activeNormalAppearance(animated: true)
        
        self.dist.constant = defaultDist
        UIView.animate(withDuration: animationDuration as! TimeInterval, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            
        })
    }
}
