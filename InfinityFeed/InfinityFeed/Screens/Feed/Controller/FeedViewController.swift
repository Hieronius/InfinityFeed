import UIKit

/// Main ViewController to display the Feed
final class FeedViewController: GenericViewController<FeedView> {

	// MARK: - Dependencies

	private let loadService: AnimeLoaderProtocol
	private let fetchService: AnimeFetcherProtocol
	private let dataManager: RealmDataManagerProtocol

	// MARK: Private Properties

	private var isLoadingMoreData = false
	private var animesCash: [Anime] = []

	private var dataSource: UICollectionViewDiffableDataSource<Section, Anime>?

	// MARK: - Initialization

	init(loadService: AnimeLoaderProtocol,
		 fetchService: AnimeFetcherProtocol,
		 dataManager: RealmDataManagerProtocol) {
		self.loadService = loadService
		self.fetchService = fetchService
		self.dataManager = dataManager
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupBehaviour()
		setupDataSource()
		loadAnimesIfNeeded()

	}

	// MARK: - Deinitialization

	deinit {
		if dataManager.loadAllAnimes().isEmpty {
			dataManager.saveAllAnimes(animes: animesCash)
		} else {
			dataManager.deleteAllAnimes()
			dataManager.saveAllAnimes(animes: animesCash)
		}
	}
}

// MARK: - SetupBehaviour

private extension FeedViewController {

	func setupBehaviour() {
		rootView.collectionView.delegate = self
	}

	func loadAnimesIfNeeded() {
		if dataManager.loadAllAnimes().isEmpty {
			loadInitialData()
		} else {
			animesCash = dataManager.loadAllAnimes()
			applySnapshot(animesCash)
		}
	}

}

// MARK: - Network

private extension FeedViewController {

	func loadInitialData() {
		Task {
			do {
				let rawData = try await loadService.getData()
				let initialAnimes = try await fetchService.fetchAnimes(from: rawData)

				loadService.incrementPage()

				let uniqueNewAnimes = initialAnimes.filter { newAnime in
					!animesCash.contains { existingAnime in
						existingAnime.title == newAnime.title
					}
				}
				animesCash.append(contentsOf: uniqueNewAnimes)

				applySnapshot(animesCash)
			} catch {
				print("Error loading initial data: \(error)")
			}
		}
	}

	func loadMoreData() {
		guard !isLoadingMoreData else { return }
		isLoadingMoreData = true

		Task {
			do {
				let rawData = try await loadService.getData()
				let newAnimes = try await fetchService.fetchAnimes(from: rawData)

				loadService.incrementPage()

				let uniqueNewAnimes = newAnimes.filter { newAnime in
					!animesCash.contains { existingAnime in
						existingAnime.title == newAnime.title
					}
				}

				animesCash.append(contentsOf: uniqueNewAnimes)

				applySnapshot(animesCash)

			} catch {
				print("Error loading more data: \(error)")
			}

			isLoadingMoreData = false
		}
	}
}

// MARK: - Setup DiffableDataSource

private extension FeedViewController {

	func setupDataSource() {

		dataSource = UICollectionViewDiffableDataSource<Section, Anime> (collectionView: rootView.collectionView) {
			(collectionView, indexPath, anime) -> UICollectionViewCell? in

			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCell
			else {
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

	}
}

// MARK: - UICollectionViewDelegate

extension FeedViewController: UICollectionViewDelegate {

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height

		if offsetY > contentHeight - scrollView.frame.size.height - 100 && !isLoadingMoreData {
			loadMoreData()
		}
	}
}

