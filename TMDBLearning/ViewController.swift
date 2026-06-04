import UIKit
import FirebaseAuth

final class ViewController: UIViewController {
    private let authService = AuthService()
    
    private let viewModel = MovieListViewModel()

    private let tableView = UITableView()

    private let activityIndicator = UIActivityIndicatorView(
        style: .large
    )

    private let searchController =
        UISearchController(
            searchResultsController: nil
        )
    
    private var searchTask: Task<Void, Never>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Trending Movies"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        
        view.backgroundColor = .systemBackground
        setupSearchController()
        setupTableView()
        setupActivityIndicator()
        bindViewModel()

        Task {
            await viewModel.fetchMovies()
        }
    }

    private func bindViewModel() {

        viewModel.onStateChange = { [weak self] in

            guard let self = self else { return }

            self.updateUI()
        }
    }

    private func setupTableView() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.dataSource = self
        tableView.delegate = self

        tableView.rowHeight = 140

        tableView.register(
            MovieTableViewCell.self,
            forCellReuseIdentifier: MovieTableViewCell.identifier
        )

        view.addSubview(tableView)

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }

    private func setupActivityIndicator() {

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([

            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )        ])
    }

    private func updateUI() {

        switch viewModel.state {

        case .idle:
            break

        case .loading:
            activityIndicator.startAnimating()

        case .loaded:

            activityIndicator.stopAnimating()

            tableView.reloadData()

        case .empty:

            activityIndicator.stopAnimating()

        case .error(let message):

            activityIndicator.stopAnimating()

            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default
                )
            )

            present(alert, animated: true)
        }
    }
    
    private func setupSearchController() {

        navigationItem.searchController =
            searchController

        searchController.searchBar.delegate =
            self

        searchController.obscuresBackgroundDuringPresentation =
            false

        searchController.searchBar.placeholder =
            "Search Movies"
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        viewModel.movies.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier,
            for: indexPath
        ) as? MovieTableViewCell else {

            return UITableViewCell()
        }

        let movie = viewModel.movies[indexPath.row]

        cell.configure(with: movie)

        return cell
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        let movie =
            viewModel.movies[indexPath.row]

        let detailsVC =
            MovieDetailsViewController(
                movie: movie
            )

        navigationController?.pushViewController(
            detailsVC,
            animated: true
        )
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {

        let lastRow =
            viewModel.movies.count - 1

        if indexPath.row == lastRow {

            Task {

                await viewModel.loadNextPage()
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {

    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        searchTask?.cancel()

        searchTask = Task {

            try? await Task.sleep(
                for: .milliseconds(300)
            )

            if Task.isCancelled {
                return
            }

            await viewModel.searchMovies(
                query: searchText
            )
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Task {
            await viewModel.fetchMovies()
        }
    }
    
    @objc
    private func logoutTapped() {

        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
        )

        alert.addAction(
            UIAlertAction(
                title: "Logout",
                style: .destructive
            ) { [weak self] _ in

                guard let self = self else { return }

                do {

                    try self.authService.signOut()

                    let loginVC = UINavigationController(
                        rootViewController: LoginViewController()
                    )

                    if let sceneDelegate = self.view.window?
                        .windowScene?
                        .delegate as? SceneDelegate {

                        sceneDelegate.window?.rootViewController = loginVC
                    }

                } catch {

                    print(error)
                }
            }
        )

        present(alert, animated: true)
    }
}
