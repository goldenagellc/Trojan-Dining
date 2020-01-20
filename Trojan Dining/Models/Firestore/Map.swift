//
//  Map.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 1/18/20.
//  Copyright © 2020 Hayden Shively. All rights reserved.
//

import Foundation
import Firebase

/*
 The following closure is called when initializing FsRoot.
 -- The "{Any}" wildcard will match against any string. When paths are
 -- identical except for the resolution of this wildcard
 -- (e.g. "/Users/{Any}" vs "/Users/A12B34C5"), behaviour is ambiguous.
 -- [SO DON'T DO IT!]
 --
 -- Also note that a single type can be registered with multiple paths.
 -- The reverse is not true.
 */

// TODO: there is probably a way of using more general regex matching instead of this 1 wildcard

let FS_TYPE_MAP: () -> () = {
    // COLLECTIONS
    FsRoot.shared.register(collectionType: FsC_Users.self, with: "/Users")
    FsRoot.shared.register(collectionType: FsC_Watchlist.self, with: "/Users/{Any}/Watchlist")
    
    // DOCUMENTS
    // Registration is optional, as documents can be accessed as someCollection.children.
    // Primary use-case: access a document without fetching an entire collection
    // Be careful/don't register a document type for a path at which heterogenous data exists.
    // -- e.g. "/Posts/{Any}" would be dangerous, because a Post may be an image, a link, etc.
    // -- If this must be done, design the FsDocument's constructor very carefully
    // -- Usually, using the childTypes property of an FsCollection is the better way to go
    FsRoot.shared.register(documentType: FsD_User.self, with: "/Users/{Any}")
    FsRoot.shared.register(documentType: FsD_Bool.self, with: "/Users/{Any}/Watchlist/{Any}")
}
