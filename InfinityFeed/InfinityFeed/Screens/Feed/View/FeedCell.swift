import UIKit

final class FeedCell: UICollectionViewCell {

	// MARK: Public Properties

	static let reuseIdentifier = "FeedCell"

	let containerView = UIView()
	let horizontalStackView = UIStackView()
	let imageView = UIImageView()
	let titleLabel = UILabel()
	let verticalStackView = UIStackView()
	let descriptionLabel = UILabel()

	// MARK: - Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)

		 embedViews()
		 setupAppearance()
		 setupLayout()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Configure Cell

extension FeedCell {

	func configure(with anime: Anime) {

		imageView.image = anime.image
		titleLabel.text = anime.title
		descriptionLabel.text = anime.description
		print("5 - cells get data")
	}
}

// MARK: - EmbedViews

extension FeedCell {

	func embedViews() {

		addSubview(containerView)

		containerView.addSubview(verticalStackView)

		verticalStackView.addArrangedSubview(horizontalStackView)
		verticalStackView.addArrangedSubview(descriptionLabel)

		horizontalStackView.addArrangedSubview(imageView)
		horizontalStackView.addArrangedSubview(titleLabel)

	}
}

// MARK: - SetupAppearance

extension FeedCell {

	func setupAppearance() {

//		backgroundColor = .yellow

		containerView.backgroundColor = .lightGray

		horizontalStackView.axis = .horizontal
		horizontalStackView.backgroundColor = .gray
		horizontalStackView.distribution = .fillEqually

		verticalStackView.axis = .vertical
		verticalStackView.backgroundColor = .darkGray
		verticalStackView.distribution = .fill
		verticalStackView.spacing =	5

		imageView.contentMode = .scaleAspectFit

		titleLabel.numberOfLines = 0
		descriptionLabel.numberOfLines = 0

	}
}

// MARK: SetupLayout

extension FeedCell {

	func setupLayout() {

		containerView.translatesAutoresizingMaskIntoConstraints
		= false
		horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
		verticalStackView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([

			containerView.topAnchor.constraint(equalTo: topAnchor),
			containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
			containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: trailingAnchor),

			horizontalStackView.heightAnchor.constraint(equalToConstant: 200),

			verticalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
			verticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
			
			verticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
			verticalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)

		])
	}
}
