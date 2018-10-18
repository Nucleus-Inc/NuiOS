//
//  NuCircularImageView.swift
//  VQTT
//
//  Created by Nucleus on 10/09/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

@IBDesignable
class NuCircularImageView: UIImageView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    /*override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        //self.layer.borderWidth = self.borderWidth
        //self.layer.borderColor = self.borderColor.cgColor
        //self.layer.cornerRadius = rect.width/2
    }*/
 
    
    @IBInspectable
    var borderColor:UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth:CGFloat = 0{
        didSet{
            self.layer.borderWidth = self.borderWidth
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUp()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    private func setUp(){
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.cornerRadius = self.frame.width/2
    }
    
}
