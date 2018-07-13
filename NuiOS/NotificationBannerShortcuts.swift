//
//  NotificationBannerShortcuts.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation
import NotificationBannerSwift

class NotificationBannerShortcuts{
    
    private class func setUpBanner(title: String, subtitle: String?, style:BannerStyle,completion:@escaping(_ banner:NotificationBanner)->Void){
        DispatchQueue.main.async {
            let banner = NotificationBanner(title: title, subtitle: subtitle, style: style)
            banner.subtitleLabel?.numberOfLines = 0
            banner.dismissDuration = 0.3
            completion(banner)
        }
    }
    
    class func showRequestErrorBanner(title:String="Request Error",subtitle:String?){
        showWarningBanner(title: title, subtitle: subtitle)
    }

    class func showRequestErrorBannerIfNeeded(title:String="Request Error",error:Error?){
        guard let e = error else{
            return
        }
        showWarningBanner(title: title, subtitle: e.localizedDescription)
    }

    class func showWarningBanner(title:String,subtitle:String?){
        setUpBanner(title: title, subtitle: subtitle, style: .warning) { (banner) in
            banner.onSwipeUp = {
                banner.dismiss()
            }
            banner.show()
        }
    }

    class func showErrBanner(title:String,subtitle:String?){
        setUpBanner(title: title, subtitle: subtitle, style: .danger) { (banner) in
            banner.onSwipeUp = {
                banner.dismiss()
            }
            banner.show()
        }
    }
    
    class func showSuccessBanner(title:String,subtitle:String?){
        setUpBanner(title: title, subtitle: subtitle, style: .success) { (banner) in
            banner.onSwipeUp = {
                banner.dismiss()
            }
            banner.show()
        }
    }
    
    class func showInfoBanner(title:String,subtitle:String?){
        setUpBanner(title: title, subtitle: subtitle, style: .info) { (banner) in
            banner.onSwipeUp = {
                banner.dismiss()
            }
            banner.show()
        }
    }

    class func showBanner(title:String,subtitle:String?){
        setUpBanner(title: title, subtitle: subtitle, style: .none) { (banner) in
            banner.backgroundColor = UIColor.black
            banner.onSwipeUp = {
                banner.dismiss()
            }
            banner.show()
        }
    }
}

//MARK: - Requests

extension NotificationBannerShortcuts{
    
    class func showApiErrorBanner(ApiError error:ApiError){
        let localizedMessage = error.description
        NotificationBannerShortcuts.showErrBanner(title: "Request Error", subtitle: localizedMessage)
    }

    class func showLoginErrBanner(){
        let localizedMessage = "Invalid username or password"
        NotificationBannerShortcuts.showErrBanner(title: "Invalid Credentials", subtitle: localizedMessage)
    }
    
    class func showUnavailableBanner(For type:AppSingleton.KeyType){
        if type == .phoneNumber{
            NotificationBannerShortcuts.showErrBanner(title: "Phone number unavailable", subtitle: "This phone number is in use. Try another one.")
        }
        else{
            NotificationBannerShortcuts.showErrBanner(title: "Email unavailable", subtitle: "This email is in use. Try another one.")
        }
    }
    
    class func showReqActCodeSuccess(For type:CodeTransport){
        if type == .sms{
            NotificationBannerShortcuts.showSuccessBanner(title: "SMS sent", subtitle: "A sms with the activation code was sent.")
        }
        else{
            NotificationBannerShortcuts.showSuccessBanner(title: "Email sent", subtitle: "An email with the activation code was sent.")
        }
    }

    class func showRequestRecCodeSuccess(For type:CodeTransport){
        if type == .sms{
            NotificationBannerShortcuts.showSuccessBanner(title: "SMS sent", subtitle: "A sms with the recovery code was sent.")
        }
        else{
            NotificationBannerShortcuts.showSuccessBanner(title: "Email sent", subtitle: "An email with the recovery code was sent.")
        }
    }

}
