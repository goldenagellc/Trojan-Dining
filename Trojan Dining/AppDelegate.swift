//
//  AppDelegate.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/22/18.
//  Copyright © 2019 Golden Age Technologies LLC. All rights reserved.
//

import UIKit
import UserNotifications
import AuthenticationServices
import Firebase
import FirebaseAuth
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // FIREBASE SETUP -------------------------------------------
        FirebaseApp.configure()
        
        // user account
        if let firebaseUser = Auth.auth().currentUser {
            TrojanDiningUser.shared.isSignedInWithFirebase = true
            print("Log @AppDelegate: Firebase UID = \(firebaseUser.uid)")
            if let appleUserID = firebaseUser.displayName {
                print("Log @AppDelegate: Apple UID = \(appleUserID)")
                ASAuthorizationAppleIDProvider().getCredentialState(forUserID: appleUserID) { (credentialState, error) in
                    TrojanDiningUser.shared.isSignedInWithApple = credentialState
                }
            }
        }
        
        // messaging
        Messaging.messaging().delegate = self
        Messaging.messaging().subscribe(toTopic: "NewMeals") { error in
            if let error = error {
                print("Error @AppDelegate: Failed to subscribe to NewMeals topic \(error.localizedDescription)")
                return
            }
            print("Log @AppDelegate: Successfully subscribed to NewMeals topic")
        }
        // ----------------------------------------------------------
        
        // APPLE PUSH NOTIFICATION SETUP ----------------------------
        UNUserNotificationCenter.current().delegate = self
        Self.requestAuthorizationToSendNotifications()
        #if DEBUG
        // log pending notifications for debugging purposes
        UNUserNotificationCenter.current().getPendingNotificationRequests() { requests in
            print("Log @AppDelegate: Begin listing pending notifications")
            requests.forEach { request in
                print("--> ID: \(request.identifier)\n----> Body: \(request.content.body)")
            }
            print("Log @AppDelegate: Done listing pending notifications")
        }
        #endif
        // ----------------------------------------------------------
        
        // BACKGROUND FETCH SETUP -----------------------------------
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "info.haydenshively.trojan-dining.schedule-notifications", using: nil) { task in
            
            task.expirationHandler = {
                // Do nothing
            }
            
            TrojanDiningUser.shared.fetchUserWatchlist {
                let scraperToday = WebScraper(forURL: URLBuilder.url(for: .today), checkingWatchlist: true) { menu, watchlistHits in
                    
                    // TODO: there's probably a better way to manage existing notifications
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    
                    watchlistHits?.forEach { hall, mealFoodDict in
                        mealFoodDict.forEach { meal, foods in
                            AppDelegate.scheduleLocalNotification(meal: meal, hall: hall, foods: foods)
                        }
                    }
                    print("Log @AppDelegate: Successfully fetched content")
                    TrojanDiningUser.shared.updateDoc(fields: ["last_updated_notifications" : Timestamp()])
                    task.setTaskCompleted(success: true)
                }
                scraperToday.resume()
            }
        }
        // ----------------------------------------------------------
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        do {
            BGTaskScheduler.shared.cancelAllTaskRequests()
            let request = BGAppRefreshTaskRequest(identifier: "info.haydenshively.trojan-dining.schedule-notifications")
            request.earliestBeginDate = Calendar.current.startOfDay(for: Date()).addingTimeInterval(TimeInterval(24*60*60 + 60))
            try BGTaskScheduler.shared.submit(request)
            print("Log @AppDelegate: Successfully scheduled background task")
        }catch {
            print(error.localizedDescription)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}



