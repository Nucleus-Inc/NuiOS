//
//  AppSingleton+ApiErrors.swift
//  NuiOS
//
//  Created by Nucleus on 23/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation


extension AppSingleton{
    
    func processOnFailure(apiError:ApiError?,reqError:Error?){
        guard let e = reqError else{
            //check error on response.data
            if let apiError = apiError{
                if apiError.errorCode == ApiError.Code.AUT002{
                    //have to logout
                    DispatchQueue.main.async {
                        if let topVC = AppDelegate.visibleViewController(){
                            UIAlertControllerShorcuts.showOKAlert(OnVC: topVC, Title: "session_expired_title".localized, Message: "your_session_expired".localized, OKAction: { (_) in
                                DispatchQueue.main.async {
                                    AppSingleton.shared.logout()
                                    AppDelegate.logout()
                                }
                            })
                        }
                    }
                    return
                }
                NotificationBannerShortcuts.showApiErrorBanner(ApiError: apiError)
            }
            return
        }
        NotificationBannerShortcuts.showRequestErrorBanner(subtitle: e.localizedDescription)
    }
    
}
