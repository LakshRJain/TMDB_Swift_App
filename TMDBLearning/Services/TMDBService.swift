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
    
    func fetchTrendingMovies() async throws -> [Movie] {
        let url = URL(
                    string: "https://api.themoviedb.org/3/trending/movie/day"
                )!
        
        var request = URLRequest(url: url)
        
        request.setValue(
                    "Bearer \(bearerToken)",
                    forHTTPHeaderField: "Authorization"
                )
        
        let ( data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data )

        return decodedResponse.results
    }
}
