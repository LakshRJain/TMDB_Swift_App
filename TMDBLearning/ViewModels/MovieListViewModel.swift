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
    
    private var currentSearchQuery = ""

    private var isSearching: Bool {
        !currentSearchQuery.isEmpty
    }
    
    private(set) var currentPage = 1

    private(set) var totalPages = 1

    private var isLoadingMore = false
    
    init(service: MovieServiceProtocol = TMDBService()) {
        self.service = service
    }

    func fetchMovies() async {
        
        currentSearchQuery = ""
        state = .loading

        do {

            let response =
                try await service.fetchTrendingMovies(
                    page: 1
                )

            movies = response.movies

            currentPage = response.page

            totalPages = response.totalPages

            state = movies.isEmpty ? .empty : .loaded

        } catch {

            state = .error(error.localizedDescription)
        }
    }
    
    func searchMovies(
        query: String
    ) async {
        currentSearchQuery = query
        if query.isEmpty {

            await fetchMovies()

            return
        }

        state = .loading

        do {
            let response =
                try await service.searchMovies(query: query,
                    page: 1
                )

            movies = response.movies


            currentPage = response.page

            totalPages = response.totalPages

            state = movies.isEmpty
            ? .empty
            : .loaded

        } catch {

            state = .error(
                error.localizedDescription
            )
        }
    }
    
    func loadNextPage() async {

        guard !isLoadingMore else {
            return
        }

        guard currentPage < totalPages else {
            return
        }

        isLoadingMore = true

        defer {
            isLoadingMore = false
        }

        do {

            let response: PaginatedMovies

            if isSearching {

                response = try await service.searchMovies(
                    query: currentSearchQuery,
                    page: currentPage + 1
                )

            } else {

                response = try await service.fetchTrendingMovies(
                    page: currentPage + 1
                )
            }

            movies.append(
                contentsOf: response.movies
            )

            currentPage = response.page

            totalPages = response.totalPages

            state = .loaded

        } catch {

            state = .error(
                error.localizedDescription
            )
        }
    }
}
