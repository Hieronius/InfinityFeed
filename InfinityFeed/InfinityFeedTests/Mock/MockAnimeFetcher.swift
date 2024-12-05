import XCTest
import @testable InfinityFeed

final class MockAnimeFetcher: AnimeFetcherProtocol {

	func loadImage(from url: URL) async throws -> UIImage {
		return UIImage()
	}

	func fetchAnimes(from response: Response) async throws -> [Anime] {
		return response.data
	}
}
