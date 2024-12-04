import UIKit

final class FeedViewController: GenericViewController<FeedView> {

	var loadService: AnimeLoaderServiceProtocol
	var isLoadingMoreData = false
	var animeCash: [Anime] = []

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

		rootView.collectionView.delegate = self
		setupDataSource()
		loadInitialData()

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

			return footer
		}
	}

	@MainActor
	func applySnapshot(_ items: [Anime]) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Anime>()
		snapshot.appendSections([Section.main])
		snapshot.appendItems(items)

		dataSource?.apply(snapshot, animatingDifferences: true)
		print("another snapshot has been applied")

	}
}

// MARK: - Network

private extension FeedViewController {

	func loadInitialData() {
		Task {
			do {
				let rawData = try await loadService.getData()
				let initialAnimes = try await fetchAnimes(from: rawData)

				// Populate cash and storage with initial data
				animeCash += initialAnimes
				loadService.incrementPage()

				applySnapshot(animeCash) // Apply the initial snapshot with loaded animes
				print("this is an amount of cash animes")
				print(animeCash.count)
				print(animeCash.map {$0.title})
			} catch {
				print("Error loading initial data: \(error)")
			}
		}
	}

	// MARK: TODO: IT SHOULD BE AN ANOTHER ANIME FETCHER SERVICE

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
							  title: title ?? "Unowned",
							  description: description,
							  image: localImage)

			animes.append(anime)
		}
		return animes
	}

}

extension FeedViewController: UICollectionViewDelegate {

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height

		if offsetY > contentHeight - scrollView.frame.size.height - 100 && !isLoadingMoreData {
			loadMoreData()
		}
	}

	func loadMoreData() {
		print("LOADING MORE DATA")
		guard !isLoadingMoreData else { return }
		isLoadingMoreData = true

		Task {
			do {
				let rawData = try await loadService.getData()
				let newAnimes = try await fetchAnimes(from: rawData)

				loadService.incrementPage()

				// Filter out duplicates based on title
				let uniqueNewAnimes = newAnimes.filter { newAnime in
					!animeCash.contains { existingAnime in
						existingAnime.title == newAnime.title // Compare by title for uniqueness
					}
				}
				
				// Append unique items to animeCash
				animeCash.append(contentsOf: uniqueNewAnimes)

				applySnapshot(animeCash)
				print("this is an amount of cash animes")
				print(animeCash.count)
				print(animeCash.map {$0.title})

			} catch {
				print("Error loading more data: \(error)")
			}

			isLoadingMoreData = false

		}
	}
}

