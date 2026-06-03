//
//  ViewState.swift
//  TMDBLearning
//
//  Created by Laksh on 02/06/26.
//

import Foundation

enum ViewState {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}

var onStateChange: (() -> Void)?

var state: ViewState = .idle {
    didSet {
        onStateChange?()
    }
}
