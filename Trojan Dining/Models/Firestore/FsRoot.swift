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
    public private(set) static var shared: FsRoot = {
        return FsRoot()
    }()
    private init() {}
    
    private var fsCollections: [Path : FsCollection.Type] = [:]
    private var fsDocuments: [Path : FsDocument.Type] = [:]
    
    public func convert<FsC: FsCollection>(_ collection: CollectionReference, callback: @escaping (FsC) -> ()) {
        guard let key = Self.find(path: collection.path, in: fsCollections) else {
            print("Error @FsRoot.convert: no FsCollection.Type is registered for path \(collection.path)")
            return
        }
        
        let fsCollection = fsCollections[key]!
        
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error @FsRoot.convert: failed to get documents for \(collection.path) - \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("Error @FsRoot.convert: failed to get documents for \(collection.path) - snapshot was nil")
                return
            }
            guard let converted = fsCollection.init(documents: documents) as? FsC else {
                print("Error @FsRoot.convert: failed to cast collection at \(collection.path) to \(FsC.self)")
                return
            }
            callback(converted)
        }
    }
    
    public func convert<FsD: FsDocument>(_ document: DocumentReference, callback: @escaping (FsD) -> ()) {
        guard let key = Self.find(path: document.path, in: fsDocuments) else {
            print("Error @FsRoot.convert: no FsDocument.Type is registered for path \(document.path)")
            return
        }
        
        let fsDocument = fsDocuments[key]!
        
        document.getDocument { snapshot, error in
            if let error = error {
                print("Error @FsRoot.convert: failed to get document at \(document.path) - \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else {
                print("Error @FsRoot.convert: failed to get document at \(document.path) - snapshot was nil")
                return
            }
            guard let converted = fsDocument.init(uid: snapshot.documentID, json: snapshot.data() ?? [:]) as? FsD else {
                print("Error @FsRoot.convert: failed to cast document at \(document.path) to \(FsD.self)")
                return
            }
            callback(converted)
        }
    }
    
    public func register(collectionType: FsCollection.Type, with path: Path) {
        if path.depth % 2 != PathType.collection.rawValue {
            fatalError("Error @FsRoot.register: path \(path) points to a document, not a collection")
        }
        else if fsCollections[path] != nil {
            fatalError("""
                Error @FsRoot.register: path \(path) was already associated with an FsCollection.Type
                --> was \(fsCollections[path]!)
                --> attempted to replace with \(collectionType)
                """)
        }
        else {
            fsCollections[path] = collectionType
            print("Log @FsRoot.register: path \(path) will be converted by \(collectionType)")
        }
    }
    
    public func register(documentType: FsDocument.Type, with path: Path) {
        if path.depth % 2 != PathType.document.rawValue {
            fatalError("Error @FsRoot.register: path \(path) points to a collection, not a document")
        }
        else if fsDocuments[path] != nil {
            fatalError("""
            Error @FsRoot.register: path \(path) was already associated with an FsDocument.Type
            --> was \(fsDocuments[path]!)
            --> attempted to replace with \(documentType)
            """)
        }
        else {
            fsDocuments[path] = documentType
            print("Log @FsRoot.register: path \(path) will be converted by \(documentType)")
        }
    }
    
    public static func find(path: Path, in dict: [Path : Any]) -> Path? {
        let pinTumblers = path.split(separator: "/")
        for key in dict.keys {
            var matches = true
            
            let cutouts = key.split(separator: "/")
            if cutouts.count != pinTumblers.count {
                continue
            }
            for (pin, cutout) in zip(pinTumblers, cutouts) {
                matches = cutout == "{Any}" || cutout == pin
                if !matches {break}
            }
            
            if matches {return key}
        }
        return nil
    }
    
    
    // MARK: - convenience functions
    public static func collection(_ collectionPath: Path) -> CollectionReference {
        return fs.collection(collectionPath)
    }
    
    public static func document(_ documentPath: Path) -> DocumentReference {
        return fs.document(documentPath)
    }
    
    public static func batch() -> WriteBatch {
        return fs.batch()
    }
    
    // MARK: - additional members
    private enum PathType: Int {
        case collection, document
    }
}

public typealias Path = String

extension Path {
    public var depth: Int {return components(separatedBy: "/").count}
}
