//
//  JLExtensions.swift
//  Pizza Day
//
//  Created by Nucleus on 06/02/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//
import UIKit
import CoreLocation

//https://material.io/components/ios/catalog/progress-indicators/activity-indicators/api-docs/Classes/MDCActivityIndicator.html



extension UITableViewCell{
    
    public var badgeValue:String?{
        get{
            if let view = self.accessoryView?.subviews.first as? UILabel, view.tag == 1{
                return view.text
            }
            return nil
        }
        set(value){
            // Create label
            if let value = value{
                let height:CGFloat = 20
                let maxWidth:CGFloat = 80
                let sideBorder:CGFloat = 3
                
                let badgeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: height, height: height))
                badgeLabel.tag = 1
                badgeLabel.text = value
                badgeLabel.lineBreakMode = .byTruncatingMiddle
                badgeLabel.textAlignment = .center
                badgeLabel.textColor = UIColor.white
                badgeLabel.font = badgeLabel.font.withSize(13)
                badgeLabel.sizeToFit()
                
                badgeLabel.translatesAutoresizingMaskIntoConstraints = false
                
                
                let textWidth = ceil(badgeLabel.attributedText?.size().width ?? badgeLabel.frame.width)
                var widthValue = (textWidth + sideBorder*2) < height ? height : textWidth + sideBorder*2
                widthValue = widthValue > maxWidth ? maxWidth : widthValue
                
                let contentView = UIView(frame: CGRect(x: 0, y: 0, width: widthValue, height: height))
                contentView.clipsToBounds = true
                contentView.layer.masksToBounds = true
                contentView.layer.cornerRadius = height/2
                contentView.backgroundColor = UIColor.red
                
                contentView.addSubview(badgeLabel)
                
                contentView.heightAnchor.constraint(equalToConstant: height).isActive = true
                contentView.widthAnchor.constraint(equalToConstant: widthValue).isActive = true
                
                badgeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
                badgeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideBorder).isActive = true
                badgeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideBorder).isActive = true

                badgeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
                badgeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
                
                self.accessoryView = contentView
            }
            else{
                if let view = self.accessoryView?.subviews.first, view.tag == 1{
                    self.accessoryView = nil
                }
            }
            
        }
    }
    
    public var badgeColor:UIColor?{
        get{
            if let contentView = self.accessoryView,
                let view = contentView.subviews.first as? UILabel, view.tag == 1{
                return contentView.backgroundColor
            }
            return nil
        }
        set(value){
            if let value = value{
                if let contentView = self.accessoryView,
                    let view = contentView.subviews.first as? UILabel, view.tag == 1{
                    contentView.backgroundColor = value
                }
            }
        }
    }
    
    public var badgeTextColor:UIColor?{
        get{
            if let view = self.accessoryView?.subviews.first as? UILabel, view.tag == 1{
                return view.textColor
            }
            return nil
        }
        set(value){
            if let value = value{
                if let view = self.accessoryView?.subviews.first as? UILabel, view.tag == 1{
                    view.textColor = value
                }
            }
        }
    }
}


extension UITableView{
    /**
     This method add your view as a subview o tableHeaderView
     */
    public func addTableHeaderView(view:UIView,height:CGFloat=0.0){
        self.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: height == 0 ? view.frame.height : height))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableHeaderView?.addSubview(view)
        
        /*let height = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width/4)
         self.view.addConstraint(height)*/
        
        let distToTop = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.tableHeaderView!, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        self.tableHeaderView!.addConstraint(distToTop)
        
        let distToBottom = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.tableHeaderView!, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant:0)
        self.tableHeaderView!.addConstraint(distToBottom)
        
        
        let leading = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.tableHeaderView!, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        self.tableHeaderView!.addConstraint(leading)
        
        let trailing = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.tableHeaderView!, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant:0)
        self.tableHeaderView!.addConstraint(trailing)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

public extension UIButton{
    func showActivityIndicator(style:UIActivityIndicatorView.Style){
        let activity:UIActivityIndicatorView
        let views = self.subviews.filter { (view) -> Bool in
            return view.tag == 100
        }
        
        if views.count > 0{
            activity = views.first! as! UIActivityIndicatorView
        }
        else{
            activity = UIActivityIndicatorView()
            activity.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(activity)
        }
        
        activity.style = style
        activity.hidesWhenStopped = true
        activity.tag = 100
        
        
        let centerY = NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(centerY)
        
        let centerX = NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(centerX)
        
        activity.startAnimating()
        
        self.isEnabled = false
    }
    
    func hideActivityIndicator(){
        let views = self.subviews.filter { (view) -> Bool in
            return view.tag == 100
        }
        
        if views.count > 0{
            let activity = views.first! as! UIActivityIndicatorView
            activity.stopAnimating()
        }
        
        self.isEnabled = true
    }
    
}

public extension CLLocation{
    
    class func withParams(params:[String:Any])->CLLocation{
        let latitude = params["latitude"] as! CLLocationDegrees
        let longitude = params["longitude"] as! CLLocationDegrees
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension NSObject{
    
    public func startListeningKeyboard(){
        registerKeyBoardNotifications()
    }
    
    public func stopListeningKeyboard(){
        removeWillShowKeyboardObserver()
        removeWillHideKeyboardObserver()
    }
    
    @objc open func keyboardWillAppear(keyboardInfo:[String:Any]){
        
    }
    
    @objc open func keyboardWillDisappear(keyboardInfo:[String:Any]){
        
    }
    
    fileprivate func registerKeyBoardNotifications(){
        addWillShowKeyboardObserver()
        addWillHideKeyboardObserver()
    }
    
    fileprivate func addWillShowKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(NSObject.showkeyBoardTarget(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    fileprivate func removeWillShowKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    fileprivate func addWillHideKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(NSObject.hideKeyBoardTarget(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func removeWillHideKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc final private func showkeyBoardTarget(_ notification:Notification){
        let info = (notification as NSNotification).userInfo as! [String:Any]
        
        keyboardWillAppear(keyboardInfo: info)
    }
    
    @objc final private func hideKeyBoardTarget(_ notification:Notification){
        let info = (notification as NSNotification).userInfo as! [String:AnyObject]
        
        keyboardWillDisappear(keyboardInfo: info)
    }
}

public extension UIScrollView{
    var currentXPage:Int{
        return Int((self.contentOffset.x)/self.frame.width)
    }
    
    var currentYPage:Int{
        return Int((self.contentOffset.y)/self.frame.height)
    }
}

public extension UINavigationBar{
    func setBackgroundInvisible(){
        self.barTintColor = UIColor.clear
        self.isTranslucent = true
        self.shadowImage = UIImage()
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
    
    private func findShadowImage(under view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1 {
            return (view as! UIImageView)
        }
        
        for subview in view.subviews {
            if let imageView = findShadowImage(under: subview) {
                return imageView
            }
        }
        return nil
    }
    
    func showShadowLine(){
        findShadowImage(under: self)?.isHidden = false
    }

    func hideShadowLine(){
        findShadowImage(under: self)?.isHidden = true
    }
    
    
    
    
}

public extension UIImage {
    
    func withEdgeInsets(_ insets:UIEdgeInsets)->UIImage?{
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.size.width, height: self.size.height), false, self.scale)
        let newImageRect = CGRect(x: insets.left, y: insets.top, width: self.size.width - (insets.right+insets.left), height: self.size.height - (insets.bottom+insets.top))
        self.draw(in: newImageRect)
        
        let borderedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return borderedImage
    }
    
    func withBorder(borderWidth width: CGFloat, borderColor color: UIColor = UIColor.clear) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.size.width, height: self.size.height), false, self.scale)
        let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let newImageRect = imageRect.insetBy(dx: width, dy: width)
        self.draw(in: newImageRect)
        
        let ctx = UIGraphicsGetCurrentContext()
        let borderRect = imageRect.insetBy(dx: width / 2, dy: width / 2)
        ctx?.setStrokeColor(color.cgColor)
        ctx?.setLineWidth(width)
        ctx?.stroke(borderRect)
        
        let borderedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return borderedImage
    }
}

public extension UIView{
    
    func rotateByAngle(angle:CGFloat){
        self.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    func drawBorderWith(Color color:UIColor,AndWidth width:CGFloat){
        self.layer.masksToBounds = true
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}

public extension String{
    
    var localized:String{
        return NSLocalizedString(self, comment: "")
    }
    
    func matchingStrings(regex: String,options:NSRegularExpression.Options) -> [[String]] {
       
        guard let regex = try? NSRegularExpression(pattern: regex, options: options) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.range(at: $0).location != NSNotFound
                ? nsString.substring(with: result.range(at: $0))
                : ""
            }
        }
    }

    
    func applyMoneyMaskForLocale(_ locale:Locale,CurrentDecimalSeparator separator:String)->String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.decimalSeparator = separator
        if let number = currencyFormatter.number(from: self){
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = NumberFormatter.Style.currency
            // localize to your grouping and decimal separator
            currencyFormatter.locale = locale
            let priceString = currencyFormatter.string(from: number) ?? self
            return priceString
        }
        return self
    }

    func applyMoneyMaskForCurrentLocale(CurrentDecimalSeparator separator:String = ".")->String{
        return self.applyMoneyMaskForLocale(Locale.current,CurrentDecimalSeparator: separator)
    }
    
    func rmMoneyMaskForLocale(_ locale:Locale)->String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = locale
        
        if let number = currencyFormatter.number(from: self){
            return number.stringValue
        }
        return self
    }

    func rmMoneyMaskForCurrentLocale()->String{
        return rmMoneyMaskForLocale(Locale.current)
    }
    
    func applyMoneyMaskWith(moneySymbol:String,separator:String)->String{
        let value = NSString(string: self).doubleValue
        let intPart = Int(value/1)
        let floatPart = Int(value.truncatingRemainder(dividingBy: 1)*100)
        let moneyString = moneySymbol+"\(intPart)"+separator+(floatPart < 10 ? "0":"")+"\(floatPart)"
        //self.replaceSubrange(0..<self.characters.count, with: moneyString)
        return moneyString
    }
    
    func removeMoneyMaskWith(moneySymbol:String,separator:String)->String{
        var value = self
        value = value.replacingOccurrences(of: moneySymbol, with: "")
        value = value.replacingOccurrences(of: " ", with: "")
        value = value.replacingOccurrences(of: separator, with: ".")
        return value
    }
}

public extension UILabel{
    func textWithMoneyMaskForCurrentLocale(Value value:Double){
        textWithMoneyMaskForLocale(Locale.current,value: value)
    }

    func textWithMoneyMaskForLocale(_ locale:Locale,value:Double){
        let currencyFormatter = NumberFormatter()
        let number = NSNumber(floatLiteral: value)
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = locale
        self.text = currencyFormatter.string(from: number) ?? "\(value)"
    }
    
    func textWithMoneyMaskUsing(moneySymbol:String,separator:String,value:Double!){
        let intPart = Int(value/1)
        let floatPart = Int(value.truncatingRemainder(dividingBy: 1)*100)
        self.text = moneySymbol+"\(intPart)"+separator+(floatPart < 10 ? "0":"")+"\(floatPart)"
    }
}

public extension UITextField{
    func inputViewAsPickerView(WithDelegate delegate:UIPickerViewDelegate, AndDataSource dataSource:UIPickerViewDataSource){
        let picker = UIPickerView()
        picker.delegate = delegate
        picker.dataSource = dataSource
        
        self.inputView = picker
        //pickerView.delegate = delegate
        //pickerView.dataSource = dataSource
    }
    
    func inputAccViewAsToolBar(WithItems items:[UIBarButtonItem]){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
        toolBar.setItems(items, animated: false)
        self.inputAccessoryView = toolBar
        toolBar.setItems(items, animated: false)
    }
    
    
    
    
    func textWithMoneyMaskForCurrentLocale(Value value:Double){
        textWithMoneyMaskForLocale(Locale.current,value: value)
    }
    
    func textWithMoneyMaskForLocale(_ locale:Locale,value:Double){
        let currencyFormatter = NumberFormatter()
        let number = NSNumber(floatLiteral: value)
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.formatterBehavior = .behavior10_4
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = locale
        
        self.text = currencyFormatter.string(from: number) ?? "\(value)"
    }
    
    func moneyMaskedTextToValueForLocale(_ locale:Locale)->Double{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = locale
        
        if let text = self.text, let number = currencyFormatter.number(from: text){
            return number.doubleValue
        }
        return 0
    }
    
    func moneyMaskedTextToValueForCurrentLocale()->Double{
        return moneyMaskedTextToValueForLocale(Locale.current)
    }


    
    func textWithMoneyMaskUsing(moneySymbol:String,separator:String,value:Double!){
        let intPart = Int(value/1)
        let floatPart = Int(value.truncatingRemainder(dividingBy: 1)*100)
        self.text = moneySymbol+"\(intPart)"+separator+(floatPart < 10 ? "0":"")+"\(floatPart)"
    }
    
    func addToMoneyMaskedText(String string:String){
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = Locale.current
        
        let zeroStr = currencyFormatter.string(from:0) ?? "0"
        if let current = self.text, !current.isEmpty{
            if string == ""{// remove
                let tempStr = String(current.prefix(current.count - 1))
                if let value = currencyFormatter.number(from: tempStr)?.doubleValue {
                    let newValue = value/10
                    let newStr = currencyFormatter.string(from: NSNumber(floatLiteral: newValue)) ?? current
                    self.text = newStr
                }
            }
            else{
                let tempStr = current+string
                if let value = currencyFormatter.number(from: tempStr)?.doubleValue {
                    let newValue = value*10
                    self.text = currencyFormatter.string(from: NSNumber(floatLiteral: newValue)) ?? current
                }
            }
        }
        else{
            self.text = zeroStr
            addToMoneyMaskedText(String: string)
        }
        
        /*
        let separator:String = currencyFormatter.currencyDecimalSeparator
        let symbol:String = currencyFormatter.currencySymbol
        
        if var text = self.text{
            if text == ""{
                text = "0"+separator+"00"
            }
            text = text.replacingOccurrences(of: symbol, with: "")
            text = text.replacingOccurrences(of: " ", with: "")
            let beforeCommaText = text.prefix(upTo: text.range(of: separator)!.lowerBound)//.substring(to: text.range(of: ",")!.lowerBound)
            if string == "" && text.caseInsensitiveCompare("0"+separator+"00") != ComparisonResult.orderedSame{//removing some character
                text.remove(at: text.index(text.endIndex, offsetBy: -1))
                if beforeCommaText.count == 1{
                    text = text.replacingOccurrences(of: separator, with: "")
                    text = "0"+separator+text
                }
            }
            else{
                text.append(string)
                
                let beforeCommaNumber = (beforeCommaText as NSString).doubleValue
                
                if beforeCommaNumber < 10 && beforeCommaText.count == 2{
                    //removing the 0 at index 0
                    text.remove(at: text.startIndex)
                }
                
                
            }
            text = text.replacingOccurrences(of: separator, with: "")
            text = text.prefix(upTo: text.index(text.endIndex, offsetBy: -2))+separator+text.suffix(from: text.index(text.endIndex, offsetBy: -2))
            self.text = symbol+text
        }
        else{
            self.text = symbol+"0"+separator+"00"
            addToMoneyMaskedText(String: string)
        }
        */
    }
    
    func moneyMaskedTextToValueUsing(moneyMaskStrings:[String])->Double{
        if let text = self.text{
            var value = text
            for string in moneyMaskStrings{
                value = value.replacingOccurrences(of: string, with: string == "," ? "." : "")
            }
            return (value as NSString).doubleValue
        }
        return 0
    }
}

public extension UIResponder{
    class func visibleViewController()->UIViewController?{
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        
        if let rootVC = rootVC{
            return findVisibleVC(rootVC: rootVC)
        }
        return nil
    }
    
    class fileprivate func findVisibleVC(rootVC:UIViewController)->UIViewController{
        if let navC = rootVC as? UINavigationController{
            return findVisibleVC(rootVC: navC.viewControllers.last!)
        }
        else if let tabC = rootVC as? UITabBarController{
            return findVisibleVC(rootVC: tabC.selectedViewController!)
        }
        else if let presented = rootVC.presentedViewController{
            return findVisibleVC(rootVC:presented)
        }
        
        return rootVC
        
    }
}

public extension Dictionary{
    func orderedArrayOfKeys(sortBy:(_ one:Key,_ two:Key)->Bool)-> [Key]{
        return [Key](self.keys).sorted(by: sortBy)
    }
    
    func keysArray()-> [Key]{
        return [Key](self.keys)
    }
    
    mutating func insertDict(dict:Dictionary){
        for key in dict.keysArray(){
            if var val = self[key] as? Dictionary{
                if let newValue = dict[key] as? Dictionary{
                    val.insertDict(dict: newValue)
                    if let asValue = val as? Value{
                        self[key] = asValue
                    }
                }
            }
            else{
                self[key] = dict[key]
            }
        }
    }
    
}


public extension UITabBarController{
    func removeBadgeOfItemAtIndex(index:Int){
        self.tabBar.items![index].badgeValue = nil
    }
    
    func addBadgeOnItemAtIndex(index:Int,WithValue value:String){
        self.tabBar.items![index].badgeValue = value
    }
    
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.15) {
        
        let defaultY = self.view.frame.height - tabBar.frame.height/2
        if animated {
            let posAnimation = CABasicAnimation(keyPath: "position.y")
            posAnimation.fromValue =  defaultY + (hidden ? 0 : (tabBar.frame.height) + 1)
            posAnimation.toValue = defaultY + (hidden ? (tabBar.frame.height) + 1 : 0)
            posAnimation.duration = duration
            self.tabBar.layer.add(posAnimation, forKey: "pos")
            /*self.tabBar.layer.removeAnimation(forKey: "hidden")
            let hiddenAnimation = CABasicAnimation(keyPath: "opacity")
            hiddenAnimation.fromValue = hidden ? 1 : 0
            hiddenAnimation.toValue = hidden ? 0 : 1
            hiddenAnimation.duration = duration
            self.tabBar.layer.add(hiddenAnimation, forKey: "hidden")*/
        }
        self.tabBar.layer.position.y = defaultY + (hidden ? (tabBar.frame.height) + 1 : 0)
        
        //self.tabBar.layer.opacity = hidden ? 0 : 1
    }
}


public extension NSAttributedString{
    class func makeWith(string:String,emphasis:[(text:String,attr:[String:Any])])->NSAttributedString {
        
        let nString = NSString(string: string)
        let attributedString = NSMutableAttributedString(string: string, attributes: nil)
        
        for emphasy in emphasis{
            let range = nString.range(of: emphasy.text)
            for key in emphasy.attr.keysArray(){
                if let value = emphasy.attr[key]{
                    attributedString.addAttribute(NSAttributedString.Key(rawValue: key), value: value, range: range)
                }
            }
        }
        
        return attributedString
        
    }
}
/*
public extension CGSize{
    static public func * (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width*right.width, height: left.height*right.height)
    }

    static public func * (left: CGSize, right: CGFloat) -> CGSize {
        return CGSize(width: left.width*right, height: left.height*right)
    }
    
    static public func / (left: CGSize, right: CGFloat) -> CGSize {
        return CGSize(width: left.width/right, height: left.height/right)
    }
}
*/

public func * (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width*right.width, height: left.height*right.height)
}

public func * (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width*right, height: left.height*right)
}

public func / (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width/right, height: left.height/right)
}

public extension Double {
    /// Arredonda um Double conforme quantidade de casas decimais
    
    func toString(maxFractionDigits:Int=0)->String{
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = maxFractionDigits
        let formatacao = formatter.string(from: NSNumber(floatLiteral: self))!

        return formatacao
    }
   
}

public extension Date{
    
    static let ToServerFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) //TimeZone(identifier: "GMT")
        return formatter
    }()

    
    static let FromServerFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
        return formatter
    }()

    
    func stringFromDate(WithFormat formatString:String)->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = formatString
        //dateFormat.timeZone = TimeZone.current
        //dateFormat.locale = NSLocale.current
        return dateFormat.string(from: self as Date)
    }
    /**
     It is for current Locale
     parameter template: default ddMMMMyyyyHHmm
     */
    func stringFromDate(WithTemplate template:String="ddMMMMyyyyHHmm")->String{
        let dateFormat = DateFormatter()
        dateFormat.setLocalizedDateFormatFromTemplate(template)
        return dateFormat.string(from: self)
    }
    
    static func dateFrom(dateString:String,AndFormatting dateFormatString:String)->Date?{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = dateFormatString
        if let date = dateFormat.date(from: dateString){
            return date
        }
        return nil
    }
}

public extension TimeInterval{
    
    func formattedTime()->(hour:Int,min:Int,sec:Int,msec:Int){
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        let minutes = Int((self / 60).truncatingRemainder(dividingBy: 60))
        let hours = Int(self / 3600)
        
        return (hours,minutes,seconds,ms)
    }
    
    
    var min:Int{
        return Int(self / 60)
    }
    
    var hours:Int{
        return Int(self / 3600)
    }
    
    var days:Int{
        return Int(self / (3600*24))
    }
    
    var weeks:Int{
        return Int(self / (3600*24*7))
    }
    
    var months:Int{
        return Int(self / (3600*24*30))
    }
    
    var years:Int{
        return Int(self / (3600*24*365))
    }
}
