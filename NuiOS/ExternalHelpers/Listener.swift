//
//  Listener.swift
//  Upme-Customer
//
//  Created by Nucleus on 02/05/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation

//last update 03/05/2018

public typealias ListenerHandler<C> = (C,Notification)->Void

public protocol Listener:class{
    var myListeners:[NSObjectProtocol]{get set}
    
    /**
     To keep everything under
     */
    func setUpListeners()
    /**
     Do not forget to call it on deinit
     */
    func rmListeners()

    //func addListener(ForName name:Notification.Name,WithHandler handler:@escaping ListenerHandler<Self>)
}

public extension Listener where Self:AnyObject{
    
    func rmListeners(){
        myListeners.forEach({NotificationCenter.default.removeObserver($0)})
        myListeners.removeAll()
    }
    
    /**
     To add listeners use this method to avoid memory leaks
     Controller the type of your ViewController
     */
    func addListener(ForName name:Notification.Name,WithHandler handler:@escaping ListenerHandler<Self>){
        let obs = NotificationCenter.default.addObserver(forName: name, object:nil, queue: OperationQueue.current) {[weak self] (n) in
            guard let s = self else{
                return
            }
            handler(s,n)
        }
        myListeners.append(obs)
    }
}
