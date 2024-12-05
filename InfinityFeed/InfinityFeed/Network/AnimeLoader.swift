import Foundation

/// Protocol for the service to handle data loading
protocol AnimeLoaderProtocol: AnyObject {

	var baseURL: String { get }
	var session: URLSession { get }

	func getData() async throws -> Response
	func incrementPage()
}

/// Implementation of the service to handle data loading
final class AnimeLoader: AnimeLoaderProtocol {

	// MARK: - Public Properties

	let baseURL = "https://kitsu.app/api/edge/anime"

	// MARK: - Private Properties

	private var currentPage = 0
	private var perPage = 5

	private(set) var session: URLSession

	// MARK: - Initialization

	init(session: URLSession = .shared) {
		self.session = session
	}
}
// MARK: - Public Methods

extension AnimeLoader {

	/// Method to track what page we already did load
	func incrementPage() {
		currentPage += 5
	}

	/// Main method to build an API path and load the data
	func getData() async throws -> Response {

		let urlString = "\(baseURL)?page[limit]=\(perPage)&page[offset]=\(currentPage)"

		guard let url = URL(string: urlString) else {
			throw URLError(.badURL)
		}

		let (data, _) = try await session.data(from: url)
		let animes = try JSONDecoder().decode(Response.self, from: data)

		return animes
	}
}
