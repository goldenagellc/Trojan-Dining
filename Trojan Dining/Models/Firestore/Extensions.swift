//
//  Extensions.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/19/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import Foundation
import Firebase

extension CollectionReference {
    public func convert<FsC: FsCollection>(_ callback: @escaping (FsC) -> ()) {
        FsRoot.shared.convert(self, callback: callback)
    }
}

extension DocumentReference {
    public func convert<FsD: FsDocument>(_ callback: @escaping (FsD) -> ()) {
        FsRoot.shared.convert(self, callback: callback)
    }
}
