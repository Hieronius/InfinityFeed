import UIKit

final class LoadingReusableView: UICollectionReusableView {

	let activityIndicator = UIActivityIndicatorView(style: .medium)

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupView()

	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: Setup View

extension LoadingReusableView {

	func setupView() {
		backgroundColor = .darkGray
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		addSubview(activityIndicator)

		NSLayoutConstraint.activate([

			activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)

		])
	}
}
