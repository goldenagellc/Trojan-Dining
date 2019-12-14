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
import FirebaseAuth

public class TrojanDiningUser {
    
    public private(set) static var shared: TrojanDiningUser = {
        return TrojanDiningUser()
    }()
    
    public var isSignedInWithApple: ASAuthorizationAppleIDProvider.CredentialState = .notFound
    private var currentNonce: String? = nil
    
    private init() {}
    
    public func signInWithAppleRequest() -> ASAuthorizationAppleIDRequest {
        currentNonce = String.randomNonce()
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.nonce = currentNonce!.sha256()
        request.requestedScopes = nil
        return request
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
            self.isSignedInWithApple = .authorized
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
