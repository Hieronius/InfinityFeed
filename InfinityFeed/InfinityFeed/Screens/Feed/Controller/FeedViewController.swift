import UIKit

final class FeedViewController: GenericViewController<FeedView> {

	var loadService: AnimeLoaderServiceProtocol
	var animes: [Anime] = []

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

		rootView.backgroundColor = .green
		 loadAnimes()

		 populateUI()

	}
}

// MARK: - UI

extension FeedViewController {

	func populateUI() {

		DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
			guard let self else { return }
			self.rootView.testTitle.text = self.animes[0].title
			self.rootView.testDescription.text = self.animes[0].description
			self.rootView.testImage.image = self.animes[0].image
			print(self.animes.count)
		}
	}
}

// MARK: - Network

private extension FeedViewController {

	func loadAnimes() {
		Task {
			do {
				let rawData = try await loadService.getData()

				 animes = try await fetchAnimes(from: rawData)
				print(animes)
			} catch {
				print("Error fetching repositories: \(error)")
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

			let anime = Anime(title: title,
								  description: description,
								  image: localImage)

			animes.append(anime)
		}
		return animes
	}

}

