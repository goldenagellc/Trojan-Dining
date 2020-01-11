//
//  NotificationDelegate.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/11/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import UIKit
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        guard let aps = userInfo["aps"] as? [String : AnyObject] else {
            completionHandler(.failed)
            return
        }
        
        if let contentAvailable = aps["content-available"] as? Int, contentAvailable == 1 {
            // The server says to fetch data
            let start = Date()
            let scraperToday = WebScraper(forURL: URLBuilder.url(for: .today)) { menu in
                // Timing to debug
                let end = Date()
                print(end.timeIntervalSince(start))
                
                TrojanDiningUser.shared.fetchUserWatchlist {
                    let watchlist = TrojanDiningUser.shared.watchlist
                    
                    menu.forEach { meal in
                        meal.foods.forEach { foodsForAHall in
                            foodsForAHall.forEach { foodsForASection in
                                foodsForASection.forEach { food in
                                    for i in 0..<watchlist.count {
                                        if food.name.lowercased().contains(watchlist[i].lowercased()) {
                                            // User signed up to be notified about this food
                                            // SCHEDULING LOCAL NOTIFICATION -----------------------------
                                            let content = UNMutableNotificationContent()
                                            content.title = (food.name.last == "s") ? "\(food.name) are being served!" : "\(food.name) is being served!"
                                            content.body = "Look in the '\(food.section)' section at \(food.hall)"
                                            
                                            let timeToNotify: Date
                                            switch meal.name {
                                            case "Breakfast": timeToNotify = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
                                            case "Brunch": timeToNotify = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
                                            case "Lunch": timeToNotify = Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!
                                            case "Dinner": timeToNotify = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())!
                                            default: timeToNotify = Date()
                                            }
                                            
                                            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: timeToNotify)
                                            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                                            
                                            let request = UNNotificationRequest(identifier: "\(food.hall)\(food.name)", content: content, trigger: trigger)
                                            UNUserNotificationCenter.current().add(request) { error in
                                                if let error = error {
                                                    print("Error @AppDelegate: Failed to schedule local notification for \(food.name) - \(error.localizedDescription)")
                                                    return
                                                }
                                                print("Log @AppDelegate: Successfully scheduled local notification for \(food.name)")
                                            }
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    }
                    completionHandler(.newData)
                }
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
            if error != nil || !granted {
                print("Error @AppDelegate: Failed to get authorization to send notifications \(error!)")
                return
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
    
}
