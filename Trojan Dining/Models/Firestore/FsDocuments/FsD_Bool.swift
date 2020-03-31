//
//  Bool.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/18/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import Foundation
import Firebase

public struct FsD_Bool: FsDocument {
    public var uid: String
    public private(set) var bool: Bool = false
    
    public init(uid: String, bool: Bool) {
        self.uid = uid
        self.bool = bool
    }
    
    public init(uid: String, json: [String : Any]) {
        self.uid = uid
        bool = json["bool"] as? Bool ?? false
    }
    
    public func json() -> [String : Any] {
        return ["type" : "Bool", "bool" : bool]
    }
}
