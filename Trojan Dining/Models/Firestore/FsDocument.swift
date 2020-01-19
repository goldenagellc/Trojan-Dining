//
//  Document.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/18/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import Foundation
import Firebase

public enum FsDocumentUploadMode {
    case set, merge
}

public protocol FsDocument {
    var uid: String { get }
    
    init(uid: String, json: [String : Any])
    
    func json() -> [String : Any]
    func upload(to remote: DocumentReference, using mode: FsDocumentUploadMode, in batch: WriteBatch)
}

extension FsDocument {
    public func upload(to remote: DocumentReference, using mode: FsDocumentUploadMode, in batch: WriteBatch) {
        switch mode {
        case .set: batch.setData(json(), forDocument: remote, merge: false)
        case .merge: batch.setData(json(), forDocument: remote, merge: true)
        }
    }
}
