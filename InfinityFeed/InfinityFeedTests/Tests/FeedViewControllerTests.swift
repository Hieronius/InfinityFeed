import XCTest
@testable import InfinityFeed

final class FeedViewControllerTests: XCTestCase {
	var sut: FeedViewController!
	var mockLoadService: MockAnimeLoader!
	var mockFetchService: MockAnimeFetcher!
	var mockDataManager: MockRealmDataManager!

	override func setUp() {
		super.setUp()
		mockLoadService = MockAnimeLoader()
		mockFetchService = MockAnimeFetcher()
		mockDataManager = MockRealmDataManager()
		sut = FeedViewController(loadService: mockLoadService,
								 fetchService: mockFetchService,
								 dataManager: mockDataManager)
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	func testLoadAnimesIfNeededWhenRealmIsEmpty() {

		mockDataManager.animesToReturn = []

		sut.loadAnimesIfNeeded()

		XCTAssertTrue(mockLoadService.isDataLoaded, "Initial data should be loaded when Realm is empty.")
	}

	func testLoadAnimesIfNeededWhenRealmIsNotEmpty() {

		let existingAnimes = [Anime(id: UUID(), title: "Existing Anime", description: "Description", image: nil)]
		mockDataManager.animesToReturn = existingAnimes

		sut.loadAnimesIfNeeded()

		XCTAssertEqual(sut.animesCash.count, existingAnimes.count, "Should load existing animes from Realm.")
	}

	func testLoadInitialData_ShouldFetchAndStoreUniqueAnimes() {
		let newAnimes = [Anime(id: UUID(), title: "New Anime", description: "Description", image: nil)]
		mockLoadService.mockResponse = Response(data: newAnimes)

		sut.loadInitialData()

		XCTAssertEqual(sut.animesCash.count, newAnimes.count, "Should store unique animes after loading initial data.")
	}

	func testLoadMoreDataShouldAppendNewAnimes() {
		let initialAnimes = [Anime(id: UUID(), title: "Existing Anime", description: "Description", image: nil)]
		sut.animesCash = initialAnimes
		let additionalAnimes = [Anime(id: UUID(), title: "New Anime", description: "Description", image: nil)]
		mockLoadService.mockResponse = Response(data: additionalAnimes)

		sut.loadMoreData()

		XCTAssertEqual(sut.animesCash.count, initialAnimes.count + additionalAnimes.count, "Should append new animes to the existing list.")
	}
}
