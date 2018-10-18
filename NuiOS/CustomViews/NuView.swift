//
//  NuShadowView.swift
//  Investor
//
//  Created by Nucleus on 19/09/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

@IBDesignable
class NuView: UIView {
    
    @IBInspectable
    var shadowOpacity:Float = 0.2
    @IBInspectable
    var shadowRadius:CGFloat = 3
    @IBInspectable
    var shadowColor:UIColor = UIColor.black
    @IBInspectable
    var shadowOffset:CGSize = CGSize(width: 0, height: -3)
    
    @IBInspectable
    var cornerRadius:CGFloat = 10
    
    override var backgroundColor: UIColor?{
        get{
            guard let layerColor = cornerLayer.backgroundColor else{
                return UIColor.white
            }
            return UIColor(cgColor: layerColor)
        }
        set(value){
            super.backgroundColor = UIColor.clear
            cornerLayer.backgroundColor = value?.cgColor
        }
    }
    
    private var cornerLayer:CALayer = CALayer()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        drawShadow()
    }
    
    private func drawShadow(){
        
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.backgroundColor = UIColor.clear.cgColor
        
        cornerLayer.frame = self.bounds
        cornerLayer.cornerRadius = cornerRadius
        cornerLayer.masksToBounds = true
        cornerLayer.zPosition = -1
        
        guard let _ = cornerLayer.superlayer else{
            layer.addSublayer(cornerLayer)
            return
        }
    }
}
