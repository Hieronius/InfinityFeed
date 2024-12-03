import UIKit

final class FeedView: UIView {

	let testStackView = UIStackView()
	let testTitle = UILabel()
	let testDescription = UILabel()
	let testImage = UIImageView()


	// MARK: - Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)

		manageSubviews()
		//			embedViews()
		//			setupAppearance()
		//			setupLayout()
		//			setupData()
	}

	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension FeedView {

	func manageSubviews() {
		addSubview(testStackView)

		testStackView.addArrangedSubview(testTitle)
		testStackView.addArrangedSubview(testDescription)
		testStackView.addArrangedSubview(testImage)

		testStackView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([

			testStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
			testStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
			testStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
			testStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
		])

		testStackView.axis = .vertical
		testStackView.distribution = .fillProportionally
		testStackView.spacing = 10
		testStackView.backgroundColor = .blue
		testTitle.text = "Test Title"
		testDescription.text = "Test Description"
		testImage.image = UIImage(systemName: "checkmark.circle")

	}


}

// MARK: - Create two labels and one image view to display our response from server


