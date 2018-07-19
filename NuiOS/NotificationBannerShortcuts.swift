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
    
    class func setUpBanner(title: String, subtitle: String?, style:BannerStyle,completion:@escaping(_ banner:NotificationBanner)->Void){
        DispatchQueue.main.async {
            let banner = NotificationBanner(title: title, subtitle: subtitle, style: style)
            banner.layer.zPosition = 1000 //to make them visible over every window that appears.
            banner.subtitleLabel?.numberOfLines = 0
            banner.dismissDuration = 0.3
            completion(banner)
        }
    }
    
    class func showRequestErrorBanner(title:String="request_error".localized,subtitle:String?){
        showWarningBanner(title: title, subtitle: subtitle)
    }

    class func showRequestErrorBannerIfNeeded(title:String="request_error".localized,error:Error?){
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

    class func showNoConnectionBanner(completion:@escaping(NotificationBanner)->Void){
        setUpBanner(title: "no_connection_title".localized, subtitle: nil, style: .none) { (banner) in
            banner.backgroundColor = UIColor.black
            banner.bannerHeight = 40
            banner.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            
            banner.dismissOnSwipeUp = true
            banner.dismissOnTap = true
            banner.duration = 7
            banner.show(bannerPosition:.bottom)
            
            completion(banner)
        }
    }
    
    class func showApiErrorBanner(ApiError error:ApiError){
        let localizedMessage = error.description
        NotificationBannerShortcuts.showErrBanner(title: "request_error".localized, subtitle: localizedMessage)
    }

    class func showLoginErrBanner(){
        let localizedMessage = "invalid_login_mess".localized
        NotificationBannerShortcuts.showErrBanner(title: "invalid_credentials_login_title".localized, subtitle: localizedMessage)
    }
    
    class func showUnavailableBanner(For type:AppSingleton.KeyType){
        if type == .phoneNumber{
            NotificationBannerShortcuts.showErrBanner(title: "phoneNumber_unavailable".localized, subtitle: "phoneNumber_in_use_try_other".localized)
        }
        else{
            NotificationBannerShortcuts.showErrBanner(title: "email_unavailable".localized, subtitle: "email_in_use_try_other".localized)
        }
    }
    
    class func showReqActCodeSuccess(For type:CodeTransport){
        if type == .sms{
            NotificationBannerShortcuts.showSuccessBanner(title: "sms_sent".localized, subtitle: "sms_activ_code_sent".localized)
        }
        else{
            NotificationBannerShortcuts.showSuccessBanner(title: "email_sent".localized, subtitle: "email_activ_code_sent".localized)
        }
    }

    class func showRequestRecCodeSuccess(For type:CodeTransport){
        if type == .sms{
            NotificationBannerShortcuts.showSuccessBanner(title: "sms_sent".localized, subtitle: "sms_rec_code_sent".localized)
        }
        else{
            NotificationBannerShortcuts.showSuccessBanner(title: "email_sent".localized, subtitle: "email_rec_code_sent".localized)
        }
    }

}
