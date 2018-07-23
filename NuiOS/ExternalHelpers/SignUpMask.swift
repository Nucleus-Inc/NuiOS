//
//  SignUpMask.swift
//  NuSignUp_Example
//
//  Created by Nucleus on 30/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation


public enum SignUpMask{
    case none
    /*case cpf = 1
    case cnpj = 2
    case rg = 3
    case cep = 5*/

    //var maskRegex:String? = "([0-9]{2})([0-9]{5})([0-9]{4})" //"([0-9]{3})([0-9]{3})([0-9]{4})" // USA
    //var replacementRole:String? = "+55 ($1) $2-$3" //"+1 ($1) $2-$3" //USA

    public var mask:(regex:String,format:String){
        switch self {
        default:
            return ("","$0")
        }
    }
    
    public func applyOnText(text:String)->String{
        let mask = self.mask
        var unmaskedText:String = text
        switch self {
        default:
            break
        }
        return SignUpMask.applyCustomMask(regex: mask.regex, format: mask.format, onText: unmaskedText)
    }
    
    public func unmaskedText(_ text:String)->String{
        switch self {
        /*case .cep:
            return text.replacingOccurrences(of: "-", with: "")
        case .cnpj:
            return text.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "/", with: "")
        case .cpf:
            return text.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".", with: "")
        case .rg:
            return text.replacingOccurrences(of: ".", with: "")*/
        default:
            return text
        }
    }
    
    
    static public func applyCustomMask(regex:String,format:String, onText text:String)->String{
        return text.replacingOccurrences(of: regex, with: format, options: [.regularExpression,.anchored], range: nil)
    }
}


public enum PhoneNumber{
    case BR
    case USA
    
    
    public func mask(number:String,hasCountryCode:Bool=true)->String{
        let pattern = self.maskingPattern
        let unmaskedNumber:String
        
        switch self {
        case .BR,.USA:
            let tempUnmasked = unmask(number: number)
            unmaskedNumber = hasCountryCode ? String(tempUnmasked.suffix(tempUnmasked.count - countryCode.count)) :  tempUnmasked
        }
        return PhoneNumber.applyMask(regex: pattern.regex, format: pattern.format, onText: unmaskedNumber)
    }
    
    public var countryCode:String{
        switch self {
        case .BR:
            return "55"
        case .USA:
            return "1"
        }
    }
    
    public var maskingPattern:(regex:String,format:String){
        switch self {
        case .BR:
            return ("([0-9]{2})([0-9]{5})([0-9]{4})","+55 ($1) $2-$3")
        case .USA:
            return ("([0-9]{3})([0-9]{3})([0-9]{4})","+1 ($1) $2-$3")
        }
    }

    public func unmask(number:String)->String{
        return number.replacingOccurrences(of: "[^\\d]", with: "", options: .regularExpression, range: nil)
    }
    
    static private func applyMask(regex:String,format:String, onText text:String)->String{
        return text.replacingOccurrences(of: regex, with: format, options: [.regularExpression,.anchored], range: nil)
    }

}
