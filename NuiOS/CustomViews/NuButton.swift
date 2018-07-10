//
//  NuButton.swift
//  NuiOS
//
//  Created by Nucleus on 10/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

class NuButton: UIButton {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable
    var cornerRadius:CGFloat{
        get{
            return self.layer.cornerRadius
        }
        set(value){
            self.layer.cornerRadius = value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cornerRadius = 5
    }

}
