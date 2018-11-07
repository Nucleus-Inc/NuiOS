//
//  SignUpMask.swift
//  NuSignUp_Example
//
//  Created by Nucleus on 30/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation



protocol Mask{
    var maskingPattern:(regex:String,format:String){get}
    func mask(text:String)->String
    func unmask(_ text:String)->String
}

public enum SignUpMask:Mask{
    case none
    case cpf
    case cep
    /*case cnpj = 2
     case rg = 3
     case cep = 5*/
    
    //var maskRegex:String? = "([0-9]{2})([0-9]{5})([0-9]{4})" //"([0-9]{3})([0-9]{3})([0-9]{4})" // USA
    //var replacementRole:String? = "+55 ($1) $2-$3" //"+1 ($1) $2-$3" //USA
    
    public var maskingPattern:(regex:String,format:String){
        switch self {
        case .cpf://438.576.748-30
            return ("(\\d{3})(\\d{3})(\\d{3})(\\d{2})","$1.$2.$3-$4")
        case .cep://60765-065
            return ("(\\d{5})(\\d{3})","$1-$2")
        default:
            return ("","$0")
        }
    }
    
    public func mask(text:String)->String{
        let mask = self.maskingPattern
        let unmaskedText = unmask(text)
        return SignUpMask.applyMask(regex: mask.regex, format: mask.format, onText: unmaskedText)
    }
    
    public func unmask(_ text:String)->String{
        return text.replacingOccurrences(of: "\\D", with: "", options: .regularExpression, range: nil)
    }
    
    static private func applyMask(regex:String,format:String, onText text:String)->String{
        return text.replacingOccurrences(of: regex, with: format, options: [.regularExpression,.anchored], range: nil)
    }
}


public enum PhoneNumber:Mask{
    
    case BR //85 9 8513 7758
    case USA //1-888-452-1505
    
    
    public func mask(text:String)->String{
        let number = text
        let pattern = self.maskingPattern
        let unmaskedNumber:String
        
        switch self {
        case .BR,.USA:
            let tempUnmasked = unmask(number: number,keepCountryCode: false)
            if tempUnmasked.count == size{
                unmaskedNumber = removeCountryCode(number: tempUnmasked)
            }
            else if tempUnmasked.count == size - countryCode.count{
                unmaskedNumber = tempUnmasked
            }
            else{
                return number
            }
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
    /**
     Country Code + DDD + number
     */
    public var size:Int{
        switch self {
        case .BR:
            return 13
        case .USA:
            return 11
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
    
    private func removeMaskedCountryCode(number:String)->String{
        return number.replacingOccurrences(of: "+\(countryCode)", with: "", options: .literal, range: nil)
    }
    
    public func unmask(number:String,keepCountryCode:Bool=true)->String{
        if keepCountryCode{
            return number.replacingOccurrences(of: "\\D", with: "", options: .regularExpression, range: nil)
        }
        else{
            return number.replacingOccurrences(of: "+\(countryCode)", with: "", options: .literal, range: nil).replacingOccurrences(of: "\\D", with: "", options: .regularExpression, range: nil)
        }
    }
    
    public func unmask(_ text: String) -> String {
        return self.unmask(number: text, keepCountryCode: true)
    }
    
    
    private func removeCountryCode(number:String)->String{
        return number.replacingOccurrences(of: "^\(countryCode)", with: "", options: .regularExpression, range: nil)
    }
    
    static private func applyMask(regex:String,format:String, onText text:String)->String{
        return text.replacingOccurrences(of: regex, with: format, options: [.regularExpression,.anchored], range: nil)
    }
    
}
