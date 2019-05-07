//
//  SignUpNavController.swift
//
//  Created by Nucleus on 08/06/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import UIKit
import NuSignUp

class SignUpNavController: UINavigationController,SignUpStackC {

    private var progressView:UIProgressView!

    @IBInspectable var numbOfSteps:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addProgressView()
        // Do any additional setup after loading the view.
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
    
    private func addProgressView(){
        let subViews = navigationBar.subviews.filter({ (view) -> Bool in
            return view.tag == 100
        })
        
        if subViews.count == 1, let subview = subViews[0] as? UIProgressView{
            progressView = subview
        }
        else{
            progressView = UIProgressView()
            progressView.progressTintColor = self.navigationBar.tintColor
            progressView.trackTintColor = UIColor.lightGray.withAlphaComponent(0.3)
            progressView.translatesAutoresizingMaskIntoConstraints = false
            
            progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true
            self.navigationBar.addSubview(progressView)
            progressView.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 2).isActive = true
            progressView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 5).isActive = true
            progressView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -5).isActive = true
        }
    }
    
    
    public func updateForStep(step:Int){
        self.progressView.setProgress(Float(step)/Float(numbOfSteps), animated: true)
    }

    
    
}
