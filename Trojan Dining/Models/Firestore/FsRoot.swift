//
//  Firestore.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/18/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import Foundation
import Firebase

public final class FsRoot {
    private static let fs = Firestore.firestore()
    
//    public private(set) static var shared: FsRoot = {
//        return FsRoot()
//    }()
//    private init() {}
    
    public static func collection(_ collectionPath: String) -> CollectionReference {
        return fs.collection(collectionPath)
    }
    
    public static func document(_ documentPath: String) -> DocumentReference {
        return fs.document(documentPath)
    }
    
    public static func batch() -> WriteBatch {
        return fs.batch()
    }
}
