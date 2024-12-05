import XCTest
import @testable InfinityFeed

final class MockAnimeLoader: AnimeLoaderProtocol {
	var isDataLoaded = false
	var baseURL = ""

	func getData() async throws -> Response {
		isDataLoaded = true
		return Response(data: [])
	}

	func incrementPage() {}
}
