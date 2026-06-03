import Foundation

protocol MovieServiceProtocol {

    func fetchTrendingMovies(
        page: Int
    ) async throws -> PaginatedMovies

    func searchMovies(
        query: String,
        page: Int
    ) async throws -> PaginatedMovies
}
