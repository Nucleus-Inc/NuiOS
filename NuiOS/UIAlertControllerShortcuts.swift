//
//  UIAlertControllerShortcuts.swift
//  NuSignUp_Example
//
//  Created by Nucleus on 30/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit


class UIAlertControllerShorcuts{
    
    class func showOKAlert(OnVC vc:UIViewController,Title title:String?,Message mess:String?,OKTitle ok:String = "OK",OKAction action:((UIAlertAction)->Void)?=nil){
        let okAction = UIAlertAction(title: ok, style: .default, handler: action)
        let alertC = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        alertC.addAction(okAction)
        vc.present(alertC, animated: true, completion: nil)
    }
    
    class func showYesNoAlert(OnVC vc:UIViewController,Title title:String?,Message mess:String?,YesTitle yes:String = "yes".localized,NoTitle no:String = "no".localized,YesAction yesAction:((UIAlertAction)->Void)?=nil,NoAction noAction:((UIAlertAction)->Void)?=nil){
        
        let yesAction = UIAlertAction(title: yes, style: .default, handler: yesAction)
        let noAction = UIAlertAction(title: no, style: .cancel, handler: noAction)
        let alertC = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        alertC.addAction(yesAction)
        alertC.addAction(noAction)
        vc.present(alertC, animated: true, completion: nil)

    }
    
}
