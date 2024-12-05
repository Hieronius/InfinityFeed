import UIKit

/// `View` for custom loading indicator inside our collection view
final class LoadingReusableView: UICollectionReusableView {
	
	// MARK: Public Properties
	
	let activityIndicator = UIActivityIndicatorView(style: .medium)
	
	// MARK: - Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupView()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: Private Methods

private extension LoadingReusableView {
	
	func setupView() {
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		addSubview(activityIndicator)
		
		NSLayoutConstraint.activate([
			
			activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
}
