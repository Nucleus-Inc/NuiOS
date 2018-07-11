//
//  LinedTTextField.swift
//
//  Created by José Lucas Souza das Chagas on 24/09/17.
//  Copyright © 2017 José Lucas Souza das Chagas. All rights reserved.
//

import UIKit

@objc
class LinedTTextField: TitledTextField {
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        addBaseline()
    }
    private var baseline:CAShapeLayer = CAShapeLayer()
    
    
    
    private func addBaseline(){
        let start:CGPoint
        let end:CGPoint
        
        
        switch self.contentVerticalAlignment {
        case .bottom:
            start = CGPoint(x: 0, y: self.frame.height + 2)
            end = CGPoint(x: self.frame.width, y: self.frame.height + 2)
        case .top:
            
            let height = self.font!.lineHeight
            start = CGPoint(x: 0, y: height + 2)
            end = CGPoint(x: self.frame.width, y: height + 2)
            
            
        default:
            let height = self.font!.lineHeight
            let y = self.frame.height/2 + height/2
            start = CGPoint(x: 0, y: y + 2)
            end = CGPoint(x: self.frame.width, y: y + 2)
            
        }
        
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        baseline.path = linePath.cgPath
        baseline.strokeColor = isEditing ? editingTitleColor.cgColor  : normalTitleColor.cgColor
        baseline.lineWidth = isEditing ? 2 : 1
        baseline.lineJoin = kCALineJoinRound
        self.layer.addSublayer(baseline)
    }
    
    
    override func didBegingEditing(sender: TitledTextField) {
        super.didBegingEditing(sender: sender)
        
        
        baseline.strokeColor = isEditing ? editingTitleColor.cgColor  : normalTitleColor.cgColor
        baseline.lineWidth = 2
    }
    
    override func didEndEditing(sender: TitledTextField) {
        super.didEndEditing(sender: sender)
        
        baseline.strokeColor = isEditing ? editingTitleColor.cgColor  : normalTitleColor.cgColor
        baseline.lineWidth = 1
    }
}
