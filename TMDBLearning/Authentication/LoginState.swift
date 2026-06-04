//
//  LoginState.swift
//  TMDBLearning
//
//  Created by Laksh on 04/06/26.
//

import Foundation

enum LoginState {
    case idle
    case loading
    case success
    case error(String)
}
