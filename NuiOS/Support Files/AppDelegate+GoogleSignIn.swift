//
//  AppDelegate+GoogleSignIn.swift
//  NuiOS
//
//  Created by Nucleus on 05/10/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation
import GoogleSignIn

extension AppDelegate:GIDSignInDelegate{
    /*Client ID
     962854434183-iimmglsk3gli3v2f7cgrka9b6ifc6b55.apps.googleusercontent.com
     
     iOS URL scheme : com.googleusercontent.apps.962854434183-iimmglsk3gli3v2f7cgrka9b6ifc6b55
     */
    func setUpGoogleSignIn(){
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "962854434183-iimmglsk3gli3v2f7cgrka9b6ifc6b55.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "962854434183-e7r3pbj2fs580ni04oq0c96bld5neubj.apps.googleusercontent.com"
        
        let contacts = "https://www.googleapis.com/auth/contacts.readonly"
        GIDSignIn.sharedInstance().scopes.append(contacts)
        
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            AppSingleton.notifyUpdate(On: AppNotifications.signedInByGoogle, Object: nil, UserInfo: ["success":false])
            //NotificationBannerShortcuts.showRequestErrorBanner(subtitle: error.localizedDescription)
            NotificationBannerShortcuts.showSocialNetworkLoginErrBanner()
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            //user.serverAuthCode
            
            AppSingleton.shared.user = User(account: UserAccount(local: UserAccountLocal(email: email, displayName: fullName, phoneNumber: nil, photo: nil)))
            AppSingleton.notifyUpdate(On: AppNotifications.signedInByGoogle, Object: nil, UserInfo: ["success":true])
/*
            if let token = idToken{
                AppSingleton.shared.googleSignIn(idToken: token) { (success) in
                    AppSingleton.notifyUpdate(On: AppNotifications.signedInByGoogle, Object: nil, UserInfo: ["success":success])
                }
            }
            else{
                AppSingleton.notifyUpdate(On: AppNotifications.signedInByGoogle, Object: nil, UserInfo: ["success":false])
            }
 */
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("user disconected")
    }
}
