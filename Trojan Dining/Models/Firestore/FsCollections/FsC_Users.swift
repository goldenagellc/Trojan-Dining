//
//  FsC_Users.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/18/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import Foundation

public final class FsC_Users: FsCollection {
    public static let childTypes: [String : FsDocument.Type] = [
        "User" : FsD_User.self
    ]
    
    public var children: [FsDocument] = []
    
    public init() {}
}
