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
    
}
