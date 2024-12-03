import Foundation

// MARK: TODO - can't get objects on page 1+

protocol AnimeLoaderServiceProtocol {

	var baseURL: String { get }
	var session: URLSession { get }

	func getData() async throws -> Response
}

final class AnimeLoaderService: AnimeLoaderServiceProtocol {

	let baseURL = "https://kitsu.io/api/edge/anime"

	private var currentPage = 2
	private let perPage = 4 // if set to 5 - crush

	private(set) var session: URLSession

	init(session: URLSession = .shared) {
		self.session = session
	}

	func getData() async throws -> Response {

		let urlString = "\(baseURL)?page[limit]=\(perPage)&page[offset]=\(currentPage)"

		guard let url = URL(string: urlString) else {
		throw URLError(.badURL)
		}

		let (data, _) = try await session.data(from: url)
		let animes = try JSONDecoder().decode(Response.self, from: data)

		// MARK: TODO page counter += 1
		return animes
	}
}
