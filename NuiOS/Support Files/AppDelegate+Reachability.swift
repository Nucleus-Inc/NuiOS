//
//  AppDelegate+Reachability.swift
//  NuiOS
//
//  Created by Nucleus on 18/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit
import SwiftMessages


extension AppDelegate{
    private static let noConnectionMessages = SwiftMessages()

    //MARK: - Connection Listener
    static let reach = Reachability.forInternetConnection()

    static var thereIsConnection:Bool{
        return (reach?.currentReachabilityStatus() ?? ReachableViaWiFi) != NotReachable
    }
    
    func listenForInternetConnectionChanges(){
        AppDelegate.reach?.startNotifier()
        
        let queue = DispatchQueue(label: "noConectionBanner")
        
        NotificationCenter.default.addObserver(forName: Notification.Name.reachabilityChanged, object: nil, queue: OperationQueue.main) { (notification) in
            if AppDelegate.reach?.currentReachabilityStatus() == NotReachable{
                if UIApplication.shared.applicationState == .active || UIApplication.shared.applicationState == .inactive{
                    SwiftMessagesShortcuts.showNoConnectionBanner(Messages: AppDelegate.noConnectionMessages)
                }
                
            }
            else{
                queue.sync {
                    AppDelegate.noConnectionMessages.hideAll()
                }
            }
        }
        
        if AppDelegate.reach?.currentReachabilityStatus() == NotReachable{
            NotificationCenter.default.post(name: NSNotification.Name.reachabilityChanged, object: AppDelegate.reach)
        }
    }
    
}
