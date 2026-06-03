//
//  MovieDetailsViewController.swift
//  TMDBLearning
//
//  Created by Laksh on 03/06/26.
//

import UIKit

final class MovieDetailsViewController: UIViewController {

    private let movie: Movie

    private let scrollView = UIScrollView()

    private let contentView = UIView()

    private let posterImageView = UIImageView()

    private let titleLabel = UILabel()

    private let releaseDateLabel = UILabel()

    private let ratingLabel = UILabel()

    private let overviewLabel = UILabel()

    init(movie: Movie) {

        self.movie = movie

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        title = "Movie Details"

        setupUI()

        configureUI()
    }

    private func setupUI() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 12

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0

        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false

        ratingLabel.translatesAutoresizingMaskIntoConstraints = false

        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.numberOfLines = 0
        overviewLabel.font = .systemFont(ofSize: 16)

        view.addSubview(scrollView)

        scrollView.addSubview(contentView)

        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(overviewLabel)

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            contentView.topAnchor.constraint(
                equalTo: scrollView.topAnchor
            ),

            contentView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor
            ),

            contentView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor
            ),

            contentView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor
            ),

            contentView.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor
            ),

            posterImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 20
            ),

            posterImageView.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),

            posterImageView.widthAnchor.constraint(
                equalToConstant: 250
            ),

            posterImageView.heightAnchor.constraint(
                equalToConstant: 375
            ),

            titleLabel.topAnchor.constraint(
                equalTo: posterImageView.bottomAnchor,
                constant: 20
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 20
            ),

            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -20
            ),

            releaseDateLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 12
            ),

            releaseDateLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),

            ratingLabel.topAnchor.constraint(
                equalTo: releaseDateLabel.bottomAnchor,
                constant: 8
            ),

            ratingLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),

            overviewLabel.topAnchor.constraint(
                equalTo: ratingLabel.bottomAnchor,
                constant: 20
            ),

            overviewLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),

            overviewLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor
            ),

            overviewLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -20
            )
        ])
    }

    private func configureUI() {

        titleLabel.text = movie.title

        releaseDateLabel.text =
            "Release Date: \(movie.releaseDate ?? "Unknown")"

        ratingLabel.text =
            "⭐️ \(movie.voteAverage)"

        overviewLabel.text =
            movie.overview

        guard let posterPath = movie.posterPath else {
            return
        }

        ImageLoader.shared.loadImage(
            from: posterPath
        ) { [weak self] image in

            self?.posterImageView.image = image
        }
    }
}
