import XCTest
@testable import InfinityFeed

final class AnimeLoaderTests: XCTestCase {
	var sut: AnimeLoader!
	var mockSession: MockURLSession!

	override func setUp() {
		super.setUp()
		mockSession = MockURLSession()
		sut = AnimeLoader(session: mockSession)
	}

	override func tearDown() {
		sut = nil
		mockSession = nil
		super.tearDown()
	}

	func testGetData_WhenCalled_ReturnsResponse() async throws {
		let expectedResponse = Response(data: [])
		mockSession.data = try JSONEncoder().encode(expectedResponse)

		let response = try await sut.getData()

		XCTAssertEqual(response.data.count, expectedResponse.data.count, "The response data should match the expected response.")
	}

	func testGetData_WhenBadURL_ThrowsError() async throws {
		sut = AnimeLoader(session: MockURLSessionWithError())

		await XCTAssertThrowsError(try await sut.getData()) { error in
			XCTAssertEqual(error as? URLError, URLError(.badURL), "Should throw a bad URL error.")
		}
	}

	func testIncrementPage_ShouldIncreaseCurrentPage() {
		let initialPage = sut.currentPage

		sut.incrementPage()

		XCTAssertEqual(sut.currentPage, initialPage + 5, "Current page should increment by 5.")
	}
}

// MARK: - MOCK

class MockURLSession: URLSession {
	var data: Data?

	override func data(for request: URLRequest) async throws -> (Data, URLResponse) {
		return (data ?? Data(), URLResponse())
	}
}

class MockURLSessionWithError: URLSession {
	override func data(for request: URLRequest) async throws -> (Data, URLResponse) {
		throw URLError(.badURL)
	}
}
