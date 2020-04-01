//
//  NotificationDelegate.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/11/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Log @AppDelegate: Did receive remote notification")
        
        guard let aps = userInfo["aps"] as? [String : AnyObject] else {
            print("Error @AppDelegate: Could not retrieve APS dictionary from remote notification")
            completionHandler(.failed)
            return
        }
        
        if let contentAvailable = aps["content-available"] as? Int, contentAvailable == 1 {
            print("Log @AppDelegate: Server says to fetch content")
            // The server says to fetch data
            let scraperToday = WebScraper(forURL: URLBuilder.url(for: .today), checkingWatchlist: true) { menu, watchlistHits in
                // TODO: there's probably a better way to manage existing notifications
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                
                watchlistHits?.forEach { hall, mealFoodDict in
                    mealFoodDict.forEach { meal, foods in
                        AppDelegate.scheduleLocalNotification(meal: meal, hall: hall, foods: foods)
                    }
                }
                
                print("Log @AppDelegate: Successfully fetched content")
                TrojanDiningUser.shared.set(lastScheduledNotifications: Date())
                completionHandler(.newData)
            }
            scraperToday.resume()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // This method is called whenever a new token is generated
        
        print("Log @AppDelegate: Received APN Token \(deviceToken)")
        // post the new token to NotificationCenter, allowing other code to listen in and perform updates if necessary
        NotificationCenter.default.post(name: Notification.Name("APNToken"), object: nil, userInfo: ["token" : deviceToken])
        
        // TODO: send the token to the database so that it's accessible server-side
    }
    
    // MARK: - convenience functions
    static func requestAuthorizationToSendNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if error != nil {
                print("Error @AppDelegate: Failed to get authorization to send notifications: \(error!)")
            }else if !granted {
                print("Error @AppDelegate: Failed to get authorization to send notifications: User denied")
            }
            print("Log @AppDelegate: Successfully got authorization to send notifications")
            Self.attemptToRegisterForRemoteNotifications()
        }
    }
    
    static func attemptToRegisterForRemoteNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Log @AppDelegate: Current notification settings are \(settings)")
            
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    static func scheduleLocalNotification(meal: String, hall: String, foods: [String]) {
        let content = UNMutableNotificationContent()
        content.title = (foods.count > 1) ? "Favorite foods at \(hall)!" : "Favorite food at \(hall)!"
        content.body = foods.joined(separator: ", ")
        
        let timeToNotify: Date
        switch meal {
        case "Breakfast": timeToNotify = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
        case "Brunch": timeToNotify = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
        case "Lunch": timeToNotify = Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!
        case "Dinner": timeToNotify = Calendar.current.date(bySettingHour: 16, minute: 0, second: 0, of: Date())!
        default: timeToNotify = Date()
        }

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: timeToNotify)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "\(hall.replacingOccurrences(of: " ", with: ""))\(meal)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error @AppDelegate: Failed to schedule local notification for \(meal) at \(hall) - \(error.localizedDescription)")
                return
            }
            print("Log @AppDelegate: Successfully scheduled local notification for \(meal) at \(hall)")
        }
    }
}
