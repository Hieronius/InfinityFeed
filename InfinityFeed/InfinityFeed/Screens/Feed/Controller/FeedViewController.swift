import UIKit

final class FeedViewController: GenericViewController<FeedView> {

	var loadService: AnimeLoaderServiceProtocol
	var isLoadingMoreData = false
	var animes: [Anime] = []

	var dataSource: UICollectionViewDiffableDataSource<Section, Anime>?

	init(loadService: AnimeLoaderServiceProtocol) {
		self.loadService = loadService
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// 1. Load data from the server
		// 2. Parse the data into animes array
		// 3. Setup CollectionView, custom cells, data source
		// 4. Populate collection view with animes items
		// 5. Be ready for new data/changes -> apply new snapshot
//		scrollViewDidScroll(rootView.collectionView)
		loadAnimes()
		

		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
			self.rootView.collectionView.delegate = self
//			self.rootView.backgroundColor = .lightGray
			self.setupDataSource()
			self.applySnapshot()
			self.rootView.collectionView.reloadData()
		}

		 // populateUI()

	}
}

// MARK: - Setup UI

extension FeedViewController {

	func populateUI() {
		
	}
}

// MARK: - Setup DiffableDataSource

extension FeedViewController {

	func setupDataSource() {

		dataSource = UICollectionViewDiffableDataSource<Section, Anime> (collectionView: rootView.collectionView) {
			(collectionView, indexPath, anime) -> UICollectionViewCell? in

			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCell
			else {
				print("found no FeedCells")
				return UICollectionViewCell()

			}
			cell.configure(with: anime)
			return cell
		}

		// Loading Indicator
		dataSource?.supplementaryViewProvider = {
			(collectionView, kind, indexPath) in
			guard kind == UICollectionView.elementKindSectionFooter
			else { return nil }

			guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingFooter", for: indexPath) as? LoadingReusableView
			else { return nil }

			footer.activityIndicator.startAnimating()

			print("3 - Create and setup DiffableDataSource with CollectionView and Anime item")

			return footer
		}
	}

	func applySnapshot() {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Anime>()
		snapshot.appendSections([Section.main])
		snapshot.appendItems(animes)

		dataSource?.apply(snapshot, animatingDifferences: true)

		print("4 - get current items from `animes` array and populate collectionView with them")
	}
}

// MARK: - Network

private extension FeedViewController {

	func loadAnimes() {
		Task {
			do {
				let rawData = try await loadService.getData()

				 animes = try await fetchAnimes(from: rawData)
				print("2 - Load Animes from API and Pass it to `animes` array")
				print(animes)
			} catch {
				print("Error fetching animes: \(error)")
			}

		}
	}

	func loadImage(from url: URL) async throws -> UIImage {
		let (data, _) = try await URLSession.shared.data(from: url)
		guard let image = UIImage(data: data) else {
			throw URLError(.cannotDecodeContentData)
		}
		return image
	}

	func fetchAnimes(from response: Response) async throws -> [Anime] {
		var animes: [Anime] = []

		guard !response.data.isEmpty else { return animes }

		for datum in response.data {

			let attributes = datum.attributes

			let title = attributes.canonicalTitle
			let description = attributes.synopsis

			let posterImageURLString = attributes.posterImage.original
			var localImage: UIImage? = nil

			if let url = URL(string: posterImageURLString) {
				do {
					let image = try await loadImage(from: url)
					localImage = image
				} catch {
					print("Image loading error: \(error.localizedDescription)")
				}
			}

			let anime = Anime(id: UUID(),
							  title: title,
							  description: description,
							  image: localImage)

			animes.append(anime)
		}
		return animes
	}

}

// MARK: - Implementation of infinity Feed. ALREADY WORKING!

extension FeedViewController: UICollectionViewDelegate {

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height

		if offsetY > contentHeight - scrollView.frame.size.height - 100 && !isLoadingMoreData {
			loadMoreData()
		}
	}


	// MARK: 5 - Get more data and change the snapShot of DataSource
	func loadMoreData() {
		isLoadingMoreData = true

		DispatchQueue.global().asyncAfter(deadline: .now() + 1) { // Simulate network delay
			guard var snapshot = self.dataSource?.snapshot() else { return }

			snapshot.appendItems(self.animes)

			DispatchQueue.main.async {
				self.dataSource?.apply(snapshot, animatingDifferences: true)
				self.isLoadingMoreData = false
				self.rootView.collectionView.reloadData() // Ensure loading indicators are updated.
			}
		}
	}
}

