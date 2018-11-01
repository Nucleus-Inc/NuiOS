//
//  TitledTextField.swift
//  JLTitledTextField
//
//  Created by José Lucas Souza das Chagas on 04/04/17.
//  Copyright © 2017 José Lucas Souza das Chagas. All rights reserved.
//

import UIKit


public extension NSTextAlignment{
    
    var correspontingCAAligment:String{
        switch self {
        case .center:
            return convertFromCATextLayerAlignmentMode(CATextLayerAlignmentMode.center)
        case .right:
            return convertFromCATextLayerAlignmentMode(CATextLayerAlignmentMode.right)
        case .left:
            return convertFromCATextLayerAlignmentMode(CATextLayerAlignmentMode.left)
        case .justified:
            return convertFromCATextLayerAlignmentMode(CATextLayerAlignmentMode.justified)
        default:
            return convertFromCATextLayerAlignmentMode(CATextLayerAlignmentMode.natural)
        }
    }
    
}


public class TitledTextField: UITextField {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    public override var text: String?{
        get{
            return super.text
        }
        set(value){
            super.text = value
            if !isEditing{updateTFAppearance()}
        }
    }
    
    
    override public var clipsToBounds: Bool{
        get{
            return false
        }
        set(value){
            super.clipsToBounds = false
        }
    }
    
    override public var font: UIFont?{
        get{
            return super.font
        }
        set(value){
            super.font = value
            titleLayer.font = value//CTFontCreateWithName((font!.familyName as CFString?)!, self.font!.pointSize, nil)//titledTF.font?.familyName as? CFTypeRef
            titleLayer.fontSize = self.font!.pointSize
        }
    }
    
    @IBInspectable var title:String?{
        didSet{
            if let title = title{
                addTitle(WithTitle: title)
            }
            else{
                titleLayer.removeFromSuperlayer()
            }
        }
    }
    
    @IBInspectable var titleMoveYBy:CGFloat = -15
    @IBInspectable var titleScaleBy:CGFloat = 1
    
    
    @IBInspectable var normalTitleColor:UIColor = UIColor.black.withAlphaComponent(0.22){
        didSet{
            if !isEditing{
                titleLayer.foregroundColor = normalTitleColor.cgColor
            }
        }
    }
    
    @IBInspectable var editingTitleColor:UIColor = UIColor.black{
        didSet{
            if isEditing{
                titleLayer.foregroundColor = editingTitleColor.cgColor
            }
        }
    }
    
    //private var layersRect:CGRect = CGRect.zero
    private let animationDuration:Double = 0.3
    private let timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    var titleLayer:CATextLayer = CATextLayer()
    private var titleIsActive:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        startListening()
        //[yourView addObserver:self forKeyPath:@"bounds" options:0 context:nil];
        self.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        startListening()
        self.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    deinit {
        self.stopListening()
        self.removeObserver(self, forKeyPath: "bounds")
    }
    /*
     open func borderRect(forBounds bounds: CGRect) -> CGRect
     
     open func textRect(forBounds bounds: CGRect) -> CGRect
     
     open func placeholderRect(forBounds bounds: CGRect) -> CGRect
     
     open func editingRect(forBounds bounds: CGRect) -> CGRect
     
     open func clearButtonRect(forBounds bounds: CGRect) -> CGRect
     
     open func leftViewRect(forBounds bounds: CGRect) -> CGRect
     
     open func rightViewRect(forBounds bounds: CGRect) -> CGRect
     
     
     open func drawText(in rect: CGRect)
     
     open func drawPlaceholder(in rect: CGRect)*/
    
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.placeholderRect(forBounds: bounds)
        return isEditing ? rect : CGRect.zero
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = keyPath, key == "bounds"{
            let rect = super.placeholderRect(forBounds: bounds)
            titleLayer.frame = titleLayerFrameFor(Rect: rect)
            
            if titleIsActive{
                titleIsActive = false
                titleActiveMode()
            }
        }
    }
    
    //MARK: - TitleLayer methods
    
    private func updateTFAppearance(){
        if isEditing{
            titleActiveMode()
        }
        else if  let text = text, text != ""{
            titleActiveMode()
        }
        else{
            titleInactiveMode()
        }
    }
    
    private func addTitle(WithTitle title:String){
        titleLayer = CATextLayer()
        titleLayer.foregroundColor = normalTitleColor.cgColor
        titleLayer.string = NSLocalizedString(title, comment: "")
        titleLayer.font = font//CTFontCreateWithName((font!.familyName as CFString?)!, self.font!.pointSize, nil)//titledTF.font?.familyName as? CFTypeRef
        titleLayer.fontSize = self.font!.pointSize
        titleLayer.alignmentMode = convertToCATextLayerAlignmentMode(self.textAlignment.correspontingCAAligment)
        //titleLayer.contentsGravity = kCAGravityCenter
        titleLayer.frame = titleLayerFrameFor(Rect: super.placeholderRect(forBounds: self.bounds))//self.bounds
        
        titleLayer.isWrapped = true
        titleLayer.contentsScale = UIScreen.main.scale
        //titleLayer.backgroundColor = UIColor.green.withAlphaComponent(0.4).cgColor
        
        self.layer.addSublayer(titleLayer)
    }
    
    private func titleLayerFrameFor(Rect rect:CGRect)->CGRect{
        let height = self.font!.lineHeight
        
        switch self.contentVerticalAlignment {
        case .bottom:
            let c = height
            let y = self.frame.height - c
            return CGRect(origin: CGPoint(x: rect.origin.x, y: y), size: CGSize(width: rect.width, height: height))
            
        case .top:
            let c = height
            let y = c
            return CGRect(origin: CGPoint(x: rect.origin.x, y: y), size: CGSize(width: rect.width, height: height))
            
        default:
            let c = height/2
            return CGRect(origin: CGPoint(x: rect.origin.x, y: rect.origin.y + (rect.height/2 - c)), size: CGSize(width: rect.width, height: height))
        }
    }
    
    //MARK: TitleLayer animations
    
    private func titleActiveMode(){
        //titleLayer.removeAllAnimations()
        var animations = [CAAnimation]()
        
        if titleScaleBy > 1 {
            let _ = scaleHeight(animate: true)
        }
        let _ = scaleFont(animate: true)
        
        if let animation = addFocusOnTitle(animate:false){
            animations.append(animation)
        }
        else if let animation = rmFocusOnTitle(animate:false){
            animations.append(animation)
        }
        
        if let animation = moveTitle(animate:false){
            animations.append(animation)
        }
        
        
        let group = CAAnimationGroup()
        group.duration = animationDuration
        group.animations = animations
        group.timingFunction = timingFunction
        
        titleLayer.add(group, forKey: "activeTitle")
        
        //titleLayer.opacity = 1
        
        titleLayer.foregroundColor = isEditing ? editingTitleColor.cgColor : normalTitleColor.cgColor
        
        /*
         let height = self.font!.lineHeight
         let canMove:Bool
         switch self.contentVerticalAlignment {
         case .bottom:
         canMove = Int(titleLayer.position.y) == Int(self.frame.height - height)
         
         case .top:
         canMove = Int(titleLayer.position.y) == Int(height)
         default:
         canMove =  Int(titleLayer.position.y) == Int(self.frame.height/2)
         }
         
         if canMove{
         titleLayer.position = CGPoint(x: titleLayer.position.x, y: titleLayer.position.y + titleMoveYBy)
         }*/
        
        if !titleIsActive{
            titleLayer.frame = titleLayerFrameFor(Rect: super.placeholderRect(forBounds: self.bounds))
            titleLayer.position = CGPoint(x: titleLayer.position.x, y: titleLayer.position.y + titleMoveYBy)
            titleIsActive = true
        }
        
    }
    
    private func titleInactiveMode(){
        //titleLayer.removeAllAnimations()
        
        var animations = [CAAnimation]()
        
        if titleScaleBy > 1{
            let _ = scaleHeightBack(animate: true)
        }
        let _ = scaleFontBack(animate: true)
        
        if let animation = rmFocusOnTitle(animate: false){
            animations.append(animation)
        }
        
        if let animation = moveBackTitle(animate: false){
            animations.append(animation)
        }
        
        let group = CAAnimationGroup()
        group.duration = animationDuration
        group.animations = animations
        group.timingFunction = timingFunction
        titleLayer.add(group, forKey: "inactiveTitle")
        //titleLayer.opacity = 0
        titleLayer.foregroundColor = normalTitleColor.cgColor
        
        /*
         if Int(titleLayer.position.y) == Int(self.frame.height/2 + titleMoveYBy){
         titleLayer.position = CGPoint(x: titleLayer.position.x, y: titleLayer.position.y - titleMoveYBy)
         }*/
        
        if titleIsActive{
            titleLayer.position = CGPoint(x: titleLayer.position.x, y: titleLayer.position.y - titleMoveYBy)
            titleIsActive = false
        }
        
    }
    
    /*
     private func showTitle()->CABasicAnimation?{
     if titleLayer.opacity == 0{
     let animation = CABasicAnimation(keyPath: "opacity")
     animation.fromValue = 0
     animation.toValue = 1
     //animation.duration = animationDuration
     //titleLayer.add(animation, forKey: "opacity-1")
     //titleLayer.opacity = 1
     return animation
     }
     return nil
     }
     
     private func hideTitle()->CABasicAnimation?{
     if titleLayer.opacity == 1{
     let animation = CABasicAnimation(keyPath: "opacity")
     animation.fromValue = 1
     animation.toValue = 0
     //animation.duration = animationDuration
     //titleLayer.add(animation, forKey: "opacity-0")
     //titleLayer.opacity = 0
     return animation
     }
     return nil
     }*/
    
    //MARK: Scale animation methods
    
    private func scaleFont(animate:Bool)->CABasicAnimation?{
        /*   yourLabel.font = [UIFont boldSystemFontOfSize:35]; // set font size which you want instead of 35
         yourLabel.transform = CGAffineTransformScale(yourLabel.transform, 0.35, 0.35);
         [UIView animateWithDuration:1.0 animations:^{
         yourLabel.transform = CGAffineTransformScale(yourLabel.transform, 5, 5);
         }];*/
        
        /*let animation = CABasicAnimation(keyPath: "bounds.size.height")
         animation.fromValue = titleLayer.bounds.height
         animation.toValue = titleLayer.bounds.height*0.5
         return animation*/
        
        //only works on mac OS
        if titleLayer.fontSize == self.font!.pointSize{//if its on default state execute it
            let animation = CABasicAnimation(keyPath: "fontSize")
            animation.fromValue = titleLayer.fontSize
            animation.toValue = titleLayer.fontSize*titleScaleBy
            animation.byValue = 0.1
            if animate{
                animation.duration = animationDuration
                animation.timingFunction = timingFunction
                titleLayer.add(animation, forKey: "fontSize")
                titleLayer.fontSize *= titleScaleBy
            }
            return animation
        }
        return nil
    }
    
    private func scaleFontBack(animate:Bool)->CABasicAnimation?{
        if let font = self.font,  titleLayer.fontSize != font.pointSize{//if its on default state execute it
            let animation = CABasicAnimation(keyPath: "fontSize")
            animation.fromValue = titleLayer.fontSize
            animation.toValue = titleLayer.fontSize/titleScaleBy
            animation.byValue = 0.1
            if animate{
                animation.duration = animationDuration
                animation.timingFunction = timingFunction
                titleLayer.add(animation, forKey: "fontSize-back")
                titleLayer.fontSize = font.pointSize
            }
            return animation
        }
        return nil
    }
    
    
    private func scaleHeight(animate:Bool)->CABasicAnimation?{
        if titleLayer.fontSize == self.font!.pointSize{//if its on default state execute it
            
            let animation = CABasicAnimation(keyPath: "bounds.size.height")
            
            animation.fromValue = titleLayer.bounds.height
            animation.toValue = titleLayer.bounds.height*titleScaleBy
            animation.byValue = 0.1
            if animate{
                animation.duration = animationDuration
                animation.timingFunction = timingFunction
                titleLayer.add(animation, forKey: "layerHeight")
                titleLayer.bounds.size.height *= titleScaleBy
            }
            return animation
        }
        return nil
    }
    
    
    private func scaleHeightBack(animate:Bool)->CABasicAnimation?{
        //only works on mac OS
        if let font = self.font, titleLayer.fontSize != font.pointSize{//if its on default state execute it
            
            let animation = CABasicAnimation(keyPath: "bounds.size.height")
            animation.fromValue = titleLayer.bounds.height
            animation.toValue = titleLayer.bounds.height/titleScaleBy
            animation.byValue = 0.1
            if animate{
                animation.duration = animationDuration/2
                animation.timingFunction = timingFunction
                titleLayer.add(animation, forKey: "layerHeight-back")
                titleLayer.bounds.size.height = titleLayer.font?.lineHeight ?? font.lineHeight
            }
            return animation
        }
        return nil
    }
    
    //MARK: Title foregroundColor animation methods
    
    
    /**
     Creates an opacity animation
     if animate is true so it creates and animates it
     if false it only creates and return its instance
     */
    private func addFocusOnTitle(animate:Bool)->CABasicAnimation?{
        if titleLayer.foregroundColor! == normalTitleColor.cgColor{
            let animation = CABasicAnimation(keyPath: "foregroundColor")
            animation.fromValue = normalTitleColor.cgColor
            animation.toValue = editingTitleColor.cgColor
            if animate{
                animation.duration = animationDuration
                animation.timingFunction = timingFunction
                titleLayer.add(animation, forKey: "foregroundColor-focus")
                titleLayer.foregroundColor = editingTitleColor.cgColor
            }
            
            return animation
        }
        return nil
    }
    
    private func rmFocusOnTitle(animate:Bool)->CABasicAnimation?{
        if titleLayer.foregroundColor! == editingTitleColor.cgColor{
            let animation = CABasicAnimation(keyPath: "foregroundColor")
            animation.fromValue = editingTitleColor.cgColor
            animation.toValue = normalTitleColor.cgColor
            if animate{
                animation.duration = animationDuration
                animation.timingFunction = timingFunction
                titleLayer.add(animation, forKey: "foregroundColor-normal")
                titleLayer.foregroundColor = normalTitleColor.cgColor
            }
            
            return animation
        }
        return nil
    }
    
    //MARK: Title position animation methods
    
    private func moveTitle(animate:Bool)->CABasicAnimation?{
        if titleLayer.position.y == self.frame.height/2{
            let animation = CABasicAnimation(keyPath: "position")
            
            animation.fromValue = titleLayer.position
            
            animation.toValue = CGPoint(x: titleLayer.position.x, y: titleLayer.position.y + titleMoveYBy*titleScaleBy)
            
            animation.byValue = 0.3
            if animate{
                animation.duration = animationDuration
                animation.timingFunction = timingFunction
                titleLayer.add(animation, forKey: "position")
                
                titleLayer.position = CGPoint(x: titleLayer.position.x, y: titleLayer.position.y + titleMoveYBy)
            }
        }
        return nil
    }
    
    private func moveBackTitle(animate:Bool)->CABasicAnimation?{
        if titleLayer.position.y == self.frame.height/2 - self.frame.height/2{
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = titleLayer.position
            
            animation.toValue = CGPoint(x: titleLayer.position.x, y: titleLayer.position.y - titleMoveYBy)
            
            animation.byValue = 0.3
            if animate{
                animation.duration = animationDuration
                animation.timingFunction = timingFunction
                titleLayer.add(animation, forKey: "position-back")
                
                titleLayer.position = CGPoint(x: titleLayer.position.x, y: titleLayer.position.y - titleMoveYBy)
            }
        }
        return nil
    }
    //MARK: - Listeners
    
    private func startListening(){
        NotificationCenter.default.addObserver(self, selector: #selector(TitledTextField.didBegingEditing(sender:)), name: UITextField.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(TitledTextField.didEndEditing(sender:)), name: UITextField.textDidEndEditingNotification, object: self)
    }
    
    private func stopListening(){
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidEndEditingNotification, object: self)
    }
    
    @objc
    func didBegingEditing(sender:TitledTextField){
        updateTFAppearance()
    }
    
    @objc
    func didEndEditing(sender:TitledTextField){
        updateTFAppearance()
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATextLayerAlignmentMode(_ input: CATextLayerAlignmentMode) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCATextLayerAlignmentMode(_ input: String) -> CATextLayerAlignmentMode {
	return CATextLayerAlignmentMode(rawValue: input)
}
