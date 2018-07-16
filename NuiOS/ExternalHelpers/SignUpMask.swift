//
//  SignUpMask.swift
//  NuSignUp_Example
//
//  Created by Nucleus on 30/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public enum SignUpMask:Int{
    
    public init(name:String) {
        switch name.lowercased(){
        /*case "cpf":
            self = .cpf
        case "cnpj":
            self = .cnpj
        case "rg":
            self = .rg
        case "cep":
            self = .cep*/
        case "brphone":
            self = .brPhone
        case "usaphone":
            self = .usaPhone

        default:
            self = .none
        }
    }
    
    case none = 0
    /*case cpf = 1
    case cnpj = 2
    case rg = 3
    case cep = 5*/
    case brPhone = 6
    case usaPhone = 7

    //var maskRegex:String? = "([0-9]{2})([0-9]{5})([0-9]{4})" //"([0-9]{3})([0-9]{3})([0-9]{4})" // USA
    //var replacementRole:String? = "+55 ($1) $2-$3" //"+1 ($1) $2-$3" //USA

    public var mask:(regex:String,format:String){
        switch self {
        /*case .cep:
            return ("","")//"[00000]-[000]"
        case .cpf:
            return ("","")//"[000].[000].[000]-[00]"
        case .cnpj:
            return ("","")//"[00].}[000].[000]/[0000]-[00]"*/
        case .brPhone:
            return ("([0-9]{2})([0-9]{5})([0-9]{4})","+55 ($1) $2-$3")
        case .usaPhone:
            return ("([0-9]{3})([0-9]{3})([0-9]{4})","+1 ($1) $2-$3")
        /*case .rg:
            return ("","")//"[0].[000].[000]"*/
        default:
            return ("","$0")
        }
    }

    public func applyOnText(text:String)->String{
        let mask = self.mask
        return SignUpMask.applyCustomMask(regex: mask.regex, format: mask.format, onText: text)
    }
    
    public func unmaskedText(_ text:String)->String{
        switch self {
        case .brPhone,.usaPhone:
            return text.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
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
