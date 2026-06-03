//
//  MovieServiceProtocol.swift
//  TMDBLearning
//
//  Created by Laksh on 02/06/26.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchTrendingMovies() async throws -> [Movie]
}
