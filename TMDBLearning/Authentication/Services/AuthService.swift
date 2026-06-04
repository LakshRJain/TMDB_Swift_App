//
//  AuthService.swift
//  TMDBLearning
//
//  Created by Laksh on 04/06/26.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
    func signIn(
        email: String,
        password: String
    ) async throws
    
    func signUp(
        email: String,
        password: String
    ) async throws
    
    func signOut() throws
    
    var isUserLoggedIn: Bool {get}
}

final class AuthService : AuthServiceProtocol {
    var isUserLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
    
    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
