//
//  Watchlist.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/18/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import Foundation

public final class FsC_Watchlist: FsCollection {
    
    public static let childTypes: [String : FsD_Bool.Type] = [
        "Bool" : FsD_Bool.self
    ]
    
    public var children: [FsD_Bool] = []
    
    public init() {}
}
