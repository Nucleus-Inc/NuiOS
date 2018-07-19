//
//  AppSignUpDelegate.swift
//  NuiOS
//
//  Created by Nucleus on 11/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation
import NuSignUp

class AppSignUpDelegate:DefaultSUpSDelegate{
    
    override public func updateAppearanceOf(NextStepButton button: UIButton) {
        if reviewMode != .none{
            button.setTitle("confirm".localized, for: .normal)
        }
        else{
            button.setTitle("next".localized, for: .normal)
        }
    }
    
}
