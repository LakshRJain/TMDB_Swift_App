import UIKit

final class ViewController: UIViewController {

    private let viewModel = MovieListViewModel()

    private let tableView = UITableView()

    private let activityIndicator = UIActivityIndicatorView(
        style: .large
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Trending Movies"

        view.backgroundColor = .systemBackground

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
            )
        ])
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
