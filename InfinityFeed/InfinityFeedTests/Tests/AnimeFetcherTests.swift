import XCTest
@testable import InfinityFeed

final class AnimeFetcherTests: XCTestCase {
	var sut: AnimeFetcher!

	override func setUp() {
		super.setUp()
		sut = AnimeFetcher()
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	func testFetchAnimes_WhenResponseIsValid_ReturnsAnimes() async throws {

		let response = Response(data: [Datum(attributes: Attributes(canonicalTitle: "Test Anime", synopsis: "Description", posterImage: PosterImage(original: "http://example.com/image.jpg")))])

		let animes = try await sut.fetchAnimes(from: response)

		XCTAssertEqual(animes.count, 1, "Should return one anime from the response.")
		XCTAssertEqual(animes.first?.title, "Test Anime", "The title should match the expected title.")
	}

	func testLoadImage_WhenValidURL_ReturnsImage() async throws {

		let validURL = URL(string: "https://example.com/image.jpg")!

		let image = try await sut.loadImage(from: validURL)

		XCTAssertNotNil(image, "Should return a valid UIImage.")
	}

	func testLoadImage_WhenInvalidURL_ThrowsError() async throws {

		let invalidURL = URL(string: "https://invalid-url")!

		await XCTAssertThrowsError(try await sut.loadImage(from: invalidURL)) { error in
			XCTAssertEqual(error as? URLError, URLError(.cannotDecodeContentData), "Should throw a cannot decode content data error.")
		}
	}
}
