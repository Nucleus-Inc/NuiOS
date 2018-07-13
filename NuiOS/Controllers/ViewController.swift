//
//  ViewController.swift
//  NuiOS
//
//  Created by Nucleus on 10/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = welcomeLabel.text!+" "+(AppSingleton.shared.user?.account?.name ?? "")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

