import Foundation

enum Endpoint {

    case trending(page: Int)

    case search(
        query: String,
        page: Int
    )

    var url: URL? {

        switch self {

        case .trending(let page):

            var components = URLComponents(
                string: "https://api.themoviedb.org/3/trending/movie/day"
            )

            components?.queryItems = [
                URLQueryItem(
                    name: "page",
                    value: "\(page)"
                )
            ]

            return components?.url

        case .search(
            let query,
            let page
        ):

            var components = URLComponents(
                string: "https://api.themoviedb.org/3/search/movie"
            )

            components?.queryItems = [

                URLQueryItem(
                    name: "query",
                    value: query
                ),

                URLQueryItem(
                    name: "page",
                    value: "\(page)"
                )
            ]

            return components?.url
        }
    }
}
