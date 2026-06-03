import Foundation

@MainActor
final class MovieListViewModel {

    private let service: MovieServiceProtocol

    var movies: [Movie] = []

    var onStateChange: (() -> Void)?

    var state: ViewState = .idle {
        didSet {
            onStateChange?()
        }
    }

    init(service: MovieServiceProtocol = TMDBService()) {
        self.service = service
    }

    func fetchMovies() async {

        state = .loading

        do {

            movies = try await service.fetchTrendingMovies()

            state = movies.isEmpty ? .empty : .loaded

        } catch {

            state = .error(error.localizedDescription)
        }
    }
}
