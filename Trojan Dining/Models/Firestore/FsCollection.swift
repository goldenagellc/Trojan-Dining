//
//  Collection.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/18/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import Foundation
import Firebase

public enum FsCollectionUploadMode {
    case set, merge
}

public protocol FsCollection: class {
    // all children must be of type Child
    associatedtype Child: FsDocument
    // childTypes allows children to be subclasses of Child
    // different initializers get called depending on the "type" field on Firestore
    static var childTypes: [String : Child.Type] { get }
    
    var children: [Child] { get set }
    
    init()
    
    func upload(to remote: CollectionReference, using mode: FsCollectionUploadMode, in batch: WriteBatch, afterAddingBatchOps: @escaping () -> ())
}

extension FsCollection {
    public init(documents: [DocumentSnapshot]) {
        self.init()
        for document in documents {
            let name = document.documentID
            let json = document.data() ?? [:]
            
            guard let childTypeString = json["type"] as? String else {
                print("Error @\(Self.self).init: document \(name) has no 'type'")
                continue
            }
            guard let childType = Self.childTypes[childTypeString] else {
                print("Error @\(Self.self).init: document \(name) has unmapped 'type'")
                continue
            }
            
            children.append(childType.init(uid: name, json: json))
        }
    }
    
    /*
     Sends local children to the server using FsDocumentUploadMode.set.
     If mode is .set, calls syncDeletions.
     If mode is .merge, does nothing more.
     Calls back when finished adding operations to the batch.
     */
    public func upload(to remote: CollectionReference, using mode: FsCollectionUploadMode, in batch: WriteBatch, afterAddingBatchOps: @escaping () -> ()) {
        children.forEach({$0.upload(to: remote.document($0.uid), using: .set, in: batch)})
        
        switch mode {
        case .set: syncDeletions(to: remote, in: batch, afterAddingBatchOps: afterAddingBatchOps)
        case .merge: afterAddingBatchOps()
        }
    }
    
    /*
     For each child on the server, checks if child's UID exists in local children array.
     If it doesn't, adds a delete operation to the batch.
     Calls back when finished adding operations to the batch.
     */
    public func syncDeletions(to remote: CollectionReference, in batch: WriteBatch, afterAddingBatchOps: @escaping () -> ()) {
        let localChildrenUIDs = children.map({$0.uid})
        remote.getDocuments { snapshot, error in
            if let error = error {
                print("Error @\(Self.self).upload: \(error.localizedDescription)")
            }else {
                snapshot?.documents.forEach { remoteChild in
                    let remoteChildUID = remoteChild.documentID
                    if !localChildrenUIDs.contains(remoteChildUID) {
                        batch.deleteDocument(remote.document(remoteChildUID))
                    }
                }
            }
            afterAddingBatchOps()
        }
    }
}
