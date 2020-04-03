//
//  User.swift
//  Trojan Dining
//
//  Created by Hayden Shively on 12/14/19.
//  Copyright © 2019 Hayden Shively. All rights reserved.
//

import Foundation
import CryptoKit
import AuthenticationServices
import Firebase
import FirebaseAuth

public class TrojanDiningUser {
    
    public private(set) static var shared: TrojanDiningUser = {
        return TrojanDiningUser()
    }()
    private init() {}
    
    public var isSignedInWithApple: ASAuthorizationAppleIDProvider.CredentialState = .notFound
    public var isSignedInWithFirebase: Bool = false
    private var currentNonce: String? = nil

    public private(set) var fs_user: FsD_User? = nil
    public private(set) var fs_watchlist: FsC_Watchlist? = nil
    public var watchlist: [String] {return fs_watchlist?.children.filter({$0.bool}).map({$0.uid}) ?? []}
    
    
    
    public func signInWithAppleRequest() -> ASAuthorizationAppleIDRequest {
        currentNonce = String.randomNonce()
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.nonce = currentNonce!.sha256()
        request.requestedScopes = nil
        return request
    }
    
    public func fetch(_ callback: @escaping (FsD_User) -> ()) {
        guard let uid = self.uid else {
            print("Error @TrojanDiningUser.fetch: uid was nil, most likely due to lack of sign in")
            return
        }
        // the location of the user's profile in Firestore
        let ref = FsRoot.collection("Users").document(uid)
        // fetch and convert to Swift type
        ref.convert { (converted: FsD_User) in
            callback(converted)
        }
    }
    
    public func fetch(_ callback: @escaping (FsC_Watchlist) -> ()) {
        guard let uid = self.uid else {
            print("Error @TrojanDiningUser.fetch: uid was nil, most likely due to lack of sign in")
            return
        }
        // the location of the user's watchlist in Firestore
        let ref = FsRoot.collection("Users").document(uid).collection("Watchlist")
        // fetch and convert to Swift type
        ref.convert { (converted: FsC_Watchlist) in
            callback(converted)
        }
    }
    
    public func pull() {
        fetch { [weak self] (user: FsD_User) in self?.fs_user = user}
        fetch { [weak self] (watchlist: FsC_Watchlist) in self?.fs_watchlist = watchlist}
    }
    
    private func commit(_ completion: @escaping (WriteBatch) -> ()) {
        guard let uid = self.uid else {
            print("Error @TrojanDiningUser.fetch: uid was nil, most likely due to lack of sign in")
            return
        }
        // the location of the user's profile in Firestore
        let ref = FsRoot.collection("Users").document(uid)
        // create batch and write to it
        let batch = FsRoot.batch()
        fs_user?.upload(to: ref, using: .merge, in: batch)
        fs_watchlist?.upload(to: ref.collection("Watchlist"), using: .set, in: batch) {
            completion(batch)
        }
    }
    
    public func push() {
        commit({$0.commit()})
    }
    
    public var uid: String? {return Auth.auth().currentUser?.uid}
    
    public func set(watchlist: [String]) {
        let documents = watchlist.map({FsD_Bool(uid: $0, bool: true)})
        fs_watchlist = FsC_Watchlist()
        fs_watchlist!.children = documents
        push()
        saveWatchlistLocally(watchlist: watchlist)
    }
    
    public func set(monthlyPro: Bool) {
        if fs_user != nil {
            fs_user!.monthly_pro = monthlyPro
            push()
        }
    }
    
    public func set(lastScheduledNotifications: Date) {
        if fs_user != nil {
            fs_user!.lastScheduledNotifications = lastScheduledNotifications
            push()
        }
    }
    
    private func saveWatchlistLocally(watchlist: [String]) {
        UserDefaults.standard.set(watchlist, forKey: "Watchlist")
    }
    
    public func loadWatchlistLocally() -> [String] {
        return UserDefaults.standard.array(forKey: "Watchlist") as? [String] ?? []
    }
    
    public func fetchUserRating(for food: Food, _ callback: @escaping (Int?) -> ()) {
        // Check for permissions
        if !isSignedInWithFirebase {callback(nil); return}
        guard let uid = Auth.auth().currentUser?.uid else {
            isSignedInWithFirebase = false
            callback(nil)
            return
        }
        // Obtain food document
        let foodDoc = FsRoot.collection("Foods").document(food.name)
        // Fetch the user's rating of the food
        foodDoc.collection(Food.hallShortName(food.hall)).document(uid).getDocument() { (docSnapshot, error) in
            if error != nil {
                print("Failed to read user rating: \(error!.localizedDescription)")
                callback(nil)
                return
            }
            guard let docSnapshot = docSnapshot else {
                print("Failed to obtain docSnapshot while fetching user rating.")
                callback(nil)
                return
            }
            let rating = docSnapshot.data()?["Rating"] as? NSNumber
            if rating == nil {callback(nil)}
            else {callback(Int(truncating: rating!))}
        }
    }
    
    public func fetchAverageRating(for food: Food, _ callback: @escaping (Int?) -> ()) {
        // Check for permissions
        if !isSignedInWithFirebase {callback(nil); return}
        guard let _ = Auth.auth().currentUser?.uid else {
            isSignedInWithFirebase = false
            callback(nil)
            return
        }
        // Obtain food document
        let foodDoc = FsRoot.collection("Foods").document(food.name)
        // Fetch the average rating of the food
        foodDoc.getDocument() { (docSnapshot, error) in
            if error != nil {
                print("Failed to read average rating: \(error!.localizedDescription)")
                callback(nil)
                return
            }
            guard let docSnapshot = docSnapshot else {
                print("Failed to obtain docSnapshot while fetching average rating.")
                callback(nil)
                return
            }
            let rating = docSnapshot.data()?["Rating"] as? NSNumber
            if rating == nil {callback(nil)}
            else {callback(Int(truncating: rating!))}
        }
    }
    
    public func addRatingToDatabase(_ rating: Int, food: Food) {
        // Check for permissions
        if !isSignedInWithFirebase {return}
        guard let uid = Auth.auth().currentUser?.uid else {
            isSignedInWithFirebase = false
            return
        }
        // Obtain food document
        let foodDoc = FsRoot.collection("Foods").document(food.name)
        // Update the user's rating of the food
        foodDoc.collection(Food.hallShortName(food.hall)).document(uid).setData([
            "Rating" : rating,
            "Recency" : Timestamp(date: Date(timeIntervalSinceNow: 0.0))
        ]) { (error) in
            if error != nil {print("Failed to update rating: \(error!.localizedDescription)"); return}
            // Now re-compute the average rating based on the user's new rating
            self.averageRatingsInDatabase(for: food)
        }
    }
    
    private func averageRatingsInDatabase(for food: Food) {
        // Check for permissions
        if !isSignedInWithFirebase {return}
        guard let _ = Auth.auth().currentUser?.uid else {
            isSignedInWithFirebase = false
            return
        }
        // Obtain food document
        let foodDoc = FsRoot.collection("Foods").document(food.name)
        // Update the average rating of the food
        foodDoc.collection(Food.hallShortName(food.hall)).getDocuments() { (querySnapshot, error) in
            if error != nil {print("Failed to fetch list of ratings: \(error!.localizedDescription)"); return}
            guard let querySnapshot = querySnapshot else {
                print("Failed to obtain querySnapshot while fetching list of ratings.")
                return
            }
            // Convert list of ratings on Firebase to an array of Int's
            var ratings: [Int] = []
            for document in querySnapshot.documents {
                guard let rating = document.data()["Rating"] as? NSNumber else {continue}
                ratings.append(Int(truncating: rating))
            }
            // Compute average and save to Firebase
            let average = ratings.count > 0 ? ratings.reduce(0, +)/ratings.count : 0
            foodDoc.setData([
                "Rating" : [Food.hallShortName(food.hall) : average]
            ], merge: true)
        }
    }
    
    public func signInWithApple(using appleIDCredential: ASAuthorizationAppleIDCredential) {
        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        
        signInWithFirebase(using: idTokenString, nonce)
        saveCredentialToFirebase(appleIDCredential.user)
    }
    
    private func signInWithFirebase(using idTokenString: String, _ nonce: String) {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            // User is signed in to Firebase with Apple.
            print("Log @TrojanDiningUser: successfully signed in with Apple and with Firebase")
            self.isSignedInWithApple = .authorized
            self.isSignedInWithFirebase = true
        }
    }
    
    private func saveCredentialToFirebase(_ id: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = id
        changeRequest?.commitChanges { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
}

extension String {
    public static func randomNonce(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if length == 0 {return}

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    public func sha256() -> String {
        let inputData = Data(self.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}
