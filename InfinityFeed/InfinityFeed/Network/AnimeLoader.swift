import Foundation


protocol AnimeLoaderProtocol: AnyObject {

	var baseURL: String { get }
	var session: URLSession { get }

	func getData() async throws -> Response
	func incrementPage()
}

final class AnimeLoader: AnimeLoaderProtocol {

	let baseURL = "https://kitsu.app/api/edge/anime"

	private var currentPage = 0
	private var perPage = 5

	private(set) var session: URLSession

	init(session: URLSession = .shared) {
		self.session = session
	}

	func incrementPage() {
		currentPage += 5
	}

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
