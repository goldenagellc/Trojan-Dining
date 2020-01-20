//
//  User.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/18/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import Foundation
import Firebase

public struct FsD_User: FsDocument {
    public var uid: String
    public var monthly_pro: Bool
    public var lastScheduledNotifications: Date?
    
    public init(uid: String, monthly_pro: Bool, lastScheduledNotifications: Date? = nil) {
        self.uid = uid
        self.monthly_pro = monthly_pro
        self.lastScheduledNotifications = lastScheduledNotifications
    }
    
    public init(uid: String, json: [String : Any]) {
        self.uid = uid
        monthly_pro = json["monthly_pro"] as? Bool ?? false
        lastScheduledNotifications = (json["last_scheduled_notifications"] as? Timestamp)?.dateValue()
    }
    
    public func json() -> [String : Any] {
        var dict: [String : Any] = [:]
        dict["monthly_pro"] = monthly_pro
        if lastScheduledNotifications != nil {dict["last_scheduled_notifications"] = Timestamp(date: lastScheduledNotifications!)}
        return dict
    }
}
