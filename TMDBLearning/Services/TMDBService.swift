//
//  TMDBService.swift
//  TMDBLearning
//
//  Created by Laksh on 02/06/26.
//

import Foundation


final class TMDBService : MovieServiceProtocol {
    private let bearerToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5YWRhZGI5MjRmODMwMDFiYzQzMjI5OTcwNDU4YjUwMCIsIm5iZiI6MTc4MDM4MjEzMy44MDYwMDAyLCJzdWIiOiI2YTFlNzliNWRhMGMwZDAzY2IyNjVlYTkiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.JILF3xrRPohX8D1c9lwY6o4RGqk2EnygCYidTkkfz7U"
    
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
