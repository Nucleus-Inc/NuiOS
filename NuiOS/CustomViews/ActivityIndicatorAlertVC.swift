//
//  ActivityIndicatorAlertVC.swift
//  NuiOS
//
//  Created by Nucleus on 05/10/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

class ActivityIndicatorAlertVC: UIViewController {

    @IBOutlet private weak var infoLabel: UILabel!
    
    var message:String?
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(Message message:String?=nil){
        self.init(nibName: "ActivityIndicatorAlertVC", bundle: Bundle.main)
        self.message = message
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = message, !title.isEmpty{
            infoLabel.text = message
        }
        else{
            infoLabel.isHidden = true
        }
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
    
}
