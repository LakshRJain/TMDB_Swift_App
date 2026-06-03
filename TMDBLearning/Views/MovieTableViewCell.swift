import UIKit

final class MovieTableViewCell: UITableViewCell {

    static let identifier = "MovieTableViewCell"

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 2
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }

    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 12
            ),
            posterImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 12
            ),
            posterImageView.widthAnchor.constraint(
                equalToConstant: 80
            ),
            posterImageView.heightAnchor.constraint(
                equalToConstant: 120
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 12
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -12
            ),
            titleLabel.topAnchor.constraint(
                equalTo: posterImageView.topAnchor
            ),
            dateLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
            dateLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 8
            ),
            ratingLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
            ratingLabel.topAnchor.constraint(
                equalTo: dateLabel.bottomAnchor,
                constant: 8
            )
        ])
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        dateLabel.text = movie.releaseDate ?? "Unknown"
        ratingLabel.text = "⭐️ \(movie.voteAverage)"

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
