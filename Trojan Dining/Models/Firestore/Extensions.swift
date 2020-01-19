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
    public func convert(callback: @escaping (FsCollection) -> ()) {
        FsRoot.shared.convert(self, callback: callback)
    }
}

extension DocumentReference {
    public func convert(callback: @escaping (FsDocument) -> ()) {
        FsRoot.shared.convert(self, callback: callback)
    }
}
