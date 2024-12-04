import Foundation


protocol AnimeLoaderServiceProtocol {

	var baseURL: String { get }
	var session: URLSession { get }

	func getData() async throws -> Response
	func incrementPage()
}

final class AnimeLoaderService: AnimeLoaderServiceProtocol {

	let baseURL = "https://kitsu.app/api/edge/anime"

	private var currentPage = 0
	private let perPage = 3 // if set to 5 - crush

	private(set) var session: URLSession

	init(session: URLSession = .shared) {
		self.session = session
	}

	func incrementPage() {
		print("this is a current page")
		currentPage += 1
		print(currentPage)
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
