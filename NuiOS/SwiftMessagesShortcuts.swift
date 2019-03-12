//
//  SwiftMessagesShortcuts.swift
//  NuiOS
//
//  Created by Nucleus on 12/03/19.
//  Copyright © 2019 Nucleus. All rights reserved.
//

import Foundation
import SwiftMessages

//https://github.com/SwiftKickMobile/SwiftMessages
class SwiftMessagesShortcuts{
    
    class func setUpBanner(title: String, subtitle: String?, style:Theme,completion:@escaping(_ banner:MessageView,_ config:inout SwiftMessages.Config)->Void){
        DispatchQueue.main.async {
            let message = MessageView.viewFromNib(layout: MessageView.Layout.cardView)
            message.layer.zPosition = 1000
            message.configureContent(title: title, body: subtitle ?? "")
            message.configureTheme(style)
            
            //message.iconImageView?.isHidden = true
            message.button?.isHidden = true

            message.layoutMarginAdditions.top = 20
            //(message.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            
            var config = SwiftMessages.Config()
            config.presentationStyle = .top
            config.presentationContext = SwiftMessages.PresentationContext.window(windowLevel: UIWindow.Level.alert)
            config.interactiveHide = true
            
            completion(message,&config)
        }
    }
    
    class func showWarningBanner(title:String,subtitle:String?){
        setUpBanner(title: title, subtitle: subtitle, style: .warning) { (banner,config) in
            SwiftMessages.show(config: config, view: banner)
        }
    }
    
    class func showErrBanner(title:String,subtitle:String?){
        setUpBanner(title: title, subtitle: subtitle, style: .error) { (banner,config) in
            SwiftMessages.show(config: config, view: banner)
        }
    }
    
    class func showSuccessBanner(title:String,subtitle:String?){
        setUpBanner(title: title, subtitle: subtitle, style: .success) { (banner,config) in
            SwiftMessages.show(config: config, view: banner)
        }
    }
    
    class func showInfoBanner(title:String,subtitle:String?){
        setUpBanner(title: title, subtitle: subtitle, style: .info) { (banner,config) in
            SwiftMessages.show(config: config, view: banner)
        }
    }
    
    class func showRequestErrorBannerIfNeeded(title:String="request_error".localized,error:Error?){
        guard let e = error else{
            return
        }
        showWarningBanner(title: title, subtitle: e.localizedDescription)
    }
    
    class func showRequestErrorBanner(title:String="request_error".localized,subtitle:String?){
        showWarningBanner(title: title, subtitle: subtitle)
    }
}

//MARK: - Requests

extension SwiftMessagesShortcuts{
    
    class func showNoConnectionBanner(Messages messages:SwiftMessages){
        setUpBanner(title: "no_connection_title".localized, subtitle: nil, style: .info) { (banner,config) in
            
            banner.layoutMarginAdditions = UIEdgeInsets.zero
            banner.iconImageView?.isHidden = true
            banner.backgroundView.backgroundColor = UIColor.black
            banner.titleLabel?.textColor = UIColor.white
            banner.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
            
            (banner.backgroundView as? CornerRoundingView)?.cornerRadius = 0
            config.duration = .forever
            config.presentationStyle = SwiftMessages.PresentationStyle.bottom
            
            messages.show(config: config, view: banner)
        }
    }
    
    class func showApiErrorBanner(ApiError error:ApiError){
        let localizedMessage = error.localizedDescription
        SwiftMessagesShortcuts.showErrBanner(title: "request_error".localized, subtitle: localizedMessage)
    }
    
    class func showLoginErrBanner(){
        let localizedMessage = "invalid_login_mess".localized
        SwiftMessagesShortcuts.showErrBanner(title: "invalid_credentials_login_title".localized, subtitle: localizedMessage)
    }
    
    class func showSocialNetworkLoginErrBanner(){
        let localizedMessage = "social_network_login_error_mess".localized
        SwiftMessagesShortcuts.showErrBanner(title: "social_network_login_error_title".localized, subtitle: localizedMessage)
    }

    class func showUnavailableBanner(For type:AppSingleton.KeyType){
        if type == .phoneNumber{
            SwiftMessagesShortcuts.showErrBanner(title: "phoneNumber_unavailable".localized, subtitle: "phoneNumber_in_use_try_other".localized)
        }
        else{
            SwiftMessagesShortcuts.showErrBanner(title: "email_unavailable".localized, subtitle: "email_in_use_try_other".localized)
        }
    }
    
    class func showReqActCodeSuccess(For type:CodeTransport){
        if type == .sms{
            SwiftMessagesShortcuts.showSuccessBanner(title: "sms_sent".localized, subtitle: "sms_activ_code_sent".localized)
        }
        else{
            SwiftMessagesShortcuts.showSuccessBanner(title: "email_sent".localized, subtitle: "email_activ_code_sent".localized)
        }
    }
    
    class func showRequestRecCodeSuccess(For type:CodeTransport){
        if type == .sms{
            SwiftMessagesShortcuts.showSuccessBanner(title: "sms_sent".localized, subtitle: "sms_rec_code_sent".localized)
        }
        else{
            SwiftMessagesShortcuts.showSuccessBanner(title: "email_sent".localized, subtitle: "email_rec_code_sent".localized)
        }
    }

}
