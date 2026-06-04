//
//  LoginViewModel.swift
//  TMDBLearning
//
//  Created by Laksh on 04/06/26.
//

import Foundation

@MainActor
final class LoginViewModel {
    private let authService : AuthServiceProtocol
    
    var onStateChange: (() -> Void)?
    
    var state: LoginState = .idle{
        didSet{
            onStateChange?()
        }
    }
    
    init(
        authservice: AuthServiceProtocol = AuthService()
    ){
        self.authService = authservice
    }
    
    func login(email: String, password: String) async {
        state = .loading
        do {
            try await authService.signIn(email: email, password: password)
            state = .success
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
