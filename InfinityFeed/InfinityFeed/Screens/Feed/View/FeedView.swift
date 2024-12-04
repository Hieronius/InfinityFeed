import UIKit

final class FeedView: UIView {

	var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())


	// MARK: - Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)
		 manageSubviews()
//					embedViews()
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

		let layout = createLayout()
		collectionView = UICollectionView(frame: bounds,
										  collectionViewLayout: layout)

		collectionView.showsVerticalScrollIndicator = false
		
		addSubview(collectionView)

		collectionView.translatesAutoresizingMaskIntoConstraints = false

		collectionView.register(FeedCell.self,
								forCellWithReuseIdentifier: "FeedCell")

		collectionView.register(LoadingReusableView.self,
								forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
								withReuseIdentifier: "loadingFooter")

		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
			collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)

		])

	}

	func createLayout() -> UICollectionViewLayout {

		return UICollectionViewCompositionalLayout {
			(sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

			let itemSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .estimated(300)
			)

			let item = NSCollectionLayoutItem(layoutSize: itemSize)

			let groupSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .estimated(300)
			)

			let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
														 subitems: [item])

			let section = NSCollectionLayoutSection(group: group)

			// Add Loading Indicator
			section.boundarySupplementaryItems = [
				NSCollectionLayoutBoundarySupplementaryItem(
					layoutSize: NSCollectionLayoutSize(
						widthDimension: .fractionalWidth(1.0),
						heightDimension: .absolute(50)
					),
					elementKind:
						UICollectionView.elementKindSectionFooter,
					alignment: .bottom
				)

			]

			return section
		}
	}


}

