//
//  AppSingleton.swift
//  NuiOS
//
//  Created by Nucleus on 10/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation

//https://phraseapp.com/blog/posts/ios-localization-the-ultimate-guide-to-the-right-developer-mindset/
//https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/

class AppSingleton{
    private static let singletonQueue = DispatchQueue(label: "com.appSingleton.serialQueue")
    private static var instance:AppSingleton?
    
    
    static var shared:AppSingleton{
        guard let i = instance else{
            instance = AppSingleton()
            let copy = singletonQueue.sync {return instance!}
            return copy
        }
        let copy = singletonQueue.sync {return i}
        return copy
    }
    
    private init(){}
    
    var user:User?
    
    class func notifyUpdate(On notifName:Notification.Name,Object object:Any?=nil,UserInfo userInfo:[AnyHashable:Any]?=nil){
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: notifName, object: object, userInfo: userInfo)
        }
    }
    
    func showIntro()->Bool{
        if let firstTime = UserDefaults.standard.value(forKey: "firstTime") as? Bool{
            return firstTime
        }
        return true
    }
    
    func setShowIntro(_ value:Bool){
        UserDefaults.standard.setValue(value, forKey: "firstTime")
    }

}

struct AppNotifications{
    /**
     Executed always when there is some kind of update on user informations that need to update view.
     */
    static let userInfoUpdate = Notification.Name(rawValue: "userInfoUpdate")
    static let signedInByGoogle = Notification.Name(rawValue: "signedInByGoogle")
    static let connectedWithGoogle = Notification.Name(rawValue: "connectedWithGoogle")
}
