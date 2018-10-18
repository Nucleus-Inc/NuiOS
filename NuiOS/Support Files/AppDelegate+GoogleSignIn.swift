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
        let success:Bool
        
        if let error = error {
            print("\(error.localizedDescription)")
            success = false
        } else {
            if let token = user.authentication.idToken{
                success = true
            }
            else{
                success = false
            }
            // Perform any operations on signed in user here.
            /*let userId = user.userID                  // For client-side use only!
             let idToken = user.authentication.idToken // Safe to send to the server
             let fullName = user.profile.name
             let givenName = user.profile.givenName
             let familyName = user.profile.familyName
             let email = user.profile.email*/
        }
        
        switch signInMode(){
        case .connect:
            if success{
                AppSingleton.shared.googleConnect(idToken: user.authentication.idToken!) { (success) in
                    AppSingleton.notifyUpdate(On: AppNotifications.connectedWithGoogle, Object: nil, UserInfo: ["success":success])
                }
            }
            else{
                AppSingleton.notifyUpdate(On: AppNotifications.connectedWithGoogle, Object: nil, UserInfo: ["success":false])
            }
        case .signIn:
            if success{
                AppSingleton.shared.googleSignIn(idToken: user.authentication.idToken!) { (success) in
                    AppSingleton.notifyUpdate(On: AppNotifications.signedInByGoogle, Object: nil, UserInfo: ["success":success])
                }
            }
            else{
                AppSingleton.notifyUpdate(On: AppNotifications.signedInByGoogle, Object: nil, UserInfo: ["success":false])
            }
        case .signInSilently(let userId, let locallyUser):
            if success{
                AppSingleton.shared.getInfoDataOf(UserWithID: userId) { (success) in
                    if !success{
                        if !locallyUser{
                            AppDelegate.logout()
                        }
                    }
                    AppSingleton.notifyUpdate(On: AppNotifications.signedInByGoogle, Object: nil, UserInfo: ["success":success])
                }
            }
            else{
                AppSingleton.notifyUpdate(On: AppNotifications.signedInByGoogle, Object: nil, UserInfo: ["success":false])
            }
        }

    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("user disconected")
    }
    
    enum GoogleSignInMode{
        case signIn
        case signInSilently(userId:String,locallyUser:Bool)
        case connect
    }
    
    func signInMode()->GoogleSignInMode{
        guard let user = AppSingleton.shared.user, let userId = user._id else{
            if let id = AppSingleton.UserAuth.getUserID(){// some user logged, but not loaded
                //sign in silently of not locally saved user
                return .signInSilently(userId: id, locallyUser: false)
            }
            else{//no user logged
                //sign in normal
                return .signIn
            }
        }
        
        guard let _ = user.account?.google?.id else{// no google id
            //connect endpoint
            return .connect
        }
        
        //sign in silently of a locally saved user
        return .signInSilently(userId: userId, locallyUser: true)
    }
}

