//
//  NuNavigationBar.swift
//  NuiOS
//
//  Created by Nucleus on 10/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

class NuNavigationBar: UINavigationBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable
    private var invisible:Bool = false{
        didSet{
            if invisible{
                self.isTranslucent = true
                self.backgroundColor = UIColor.clear
                self.shadowImage = UIImage()
                self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                self.layoutIfNeeded()
            }
        }
    }

    
}
