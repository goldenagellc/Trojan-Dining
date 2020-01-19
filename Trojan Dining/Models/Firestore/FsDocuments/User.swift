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
    public var lastScheduledNotifications: Date?
    
    public init(uid: String, json: [String : Any]) {
        self.uid = uid
        lastScheduledNotifications = (json["last_scheduled_notifications"] as? Timestamp)?.dateValue()
    }
    
    public func json() -> [String : Any] {
        var dict: [String : Any] = [:]
        if lastScheduledNotifications != nil {dict["last_scheduled_notifications"] = lastScheduledNotifications!}
        return dict
    }
}
