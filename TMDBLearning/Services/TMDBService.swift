//
//  TMDBService.swift
//  TMDBLearning
//
//  Created by Laksh on 02/06/26.
//

import Foundation


final class TMDBService : MovieServiceProtocol {
    private var bearerToken: String {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "TMDBBearerToken") as? String else {
            fatalError("TMDB Bearer Token missing from Info.plist configuration.")
        }
        return token
    }
    
    private func request(
            endpoint: Endpoint
        ) async throws -> PaginatedMovies {

            guard let url = endpoint.url else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)

            request.setValue(
                "Bearer \(bearerToken)",
                forHTTPHeaderField: "Authorization"
            )

            let (data, response) =
                try await URLSession.shared.data(
                    for: request
                )

            guard let httpResponse =
                    response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {

                throw URLError(.badServerResponse)
            }

            let decodedResponse =
                try JSONDecoder().decode(
                    MovieResponse.self,
                    from: data
                )

            return PaginatedMovies(
                movies: decodedResponse.results,
                page: decodedResponse.page,
                totalPages: decodedResponse.totalPages
            )
        }

    func fetchTrendingMovies( page: Int) async throws -> PaginatedMovies {

            try await request(
                endpoint: .trending(page: page)
            )
        }

        func searchMovies(
            query: String,
            page: Int
        ) async throws -> PaginatedMovies {

            try await request(
                endpoint: .search(query:query , page: page)
            )
        }

}
