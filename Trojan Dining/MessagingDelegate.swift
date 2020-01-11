//
//  MessagingDelegate.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/11/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import Foundation
import Firebase

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        // This method is called at app startup and whenever a new token is generated
        
        print("Log @AppDelegate: Received FCM Token \(fcmToken)")
        // post the new token to NotificationCenter, allowing other code to listen in and perform updates if necessary
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: ["token" : fcmToken])
        
        // TODO: send the token to the database so that it's accessible server-side
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Log @AppDelegate: Remote message received via FCM direct channel (not APNS)")
    }
    
    // MARK: - convenience functions
    func retrieveMessagingRegistrationToken(callback: @escaping (String?) -> Void) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error @AppDelegate: Failed to retrieve registration token \(error.localizedDescription)")
                callback(nil)
                return
            }
            guard let token = result?.token else {
                print("Error @AppDelegate: Failed to retrieve registration token because result was nil")
                callback(nil)
                return
            }
            callback(token)
        }
    }
}
