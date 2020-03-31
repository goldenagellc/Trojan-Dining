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
        getDocuments { snapshot, error in
            if let error = error {
                print("Error @CollectionReference.convert: failed to get documents for \(self.path) - \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("Error @CollectionReference.convert: failed to get documents for \(self.path) - snapshot was nil")
                return
            }
            callback(FsC.init(documents: documents))
        }
    }
}

extension DocumentReference {
    public func convert<FsD: FsDocument>(_ callback: @escaping (FsD) -> ()) {
        getDocument { snapshot, error in
            if let error = error {
                print("Error @DocumentReference.convert: failed to get document at \(self.path) - \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else {
                print("Error @DocumentReference.convert: failed to get document at \(self.path) - snapshot was nil")
                return
            }
            callback(FsD.init(uid: snapshot.documentID, json: snapshot.data() ?? [:]))
        }
    }
}
