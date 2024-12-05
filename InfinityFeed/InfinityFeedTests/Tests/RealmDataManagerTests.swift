import XCTest
import RealmSwift
@testable import InfinityFeed

final class RealmDataManagerTests: XCTestCase {
	var sut: RealmDataManager!
	var realm: Realm!

	override func setUp() {
		super.setUp()

		let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
		realm = try! Realm(configuration: config)

		sut = RealmDataManager(realm: realm)
	}

	override func tearDown() {
		sut = nil
		realm = nil
		super.tearDown()
	}

	func testSaveAllAnimes_ShouldSaveAnimesToRealm() {
		let anime1 = Anime(id: UUID(), title: "Anime 1", description: "Description 1", image: nil)
		let anime2 = Anime(id: UUID(), title: "Anime 2", description: "Description 2", image: nil)

		sut.saveAllAnimes(animes: [anime1, anime2])

		let savedAnimes = sut.loadAllAnimes()
		XCTAssertEqual(savedAnimes.count, 2, "Should save two animes to Realm.")
	}

	func testLoadAllAnimes_WhenNoAnimesSaved_ShouldReturnEmptyArray() {
		let loadedAnimes = sut.loadAllAnimes()

		XCTAssertTrue(loadedAnimes.isEmpty, "Should return an empty array when no animes are saved.")
	}

	func testDeleteAllAnimes_ShouldRemoveAllAnimesFromRealm() {
		let anime1 = Anime(id: UUID(), title: "Anime 1", description: "Description 1", image: nil)
		let anime2 = Anime(id: UUID(), title: "Anime 2", description: "Description 2", image: nil)

		sut.saveAllAnimes(animes: [anime1, anime2])

		sut.deleteAllAnimes()

		let loadedAnimes = sut.loadAllAnimes()
		XCTAssertTrue(loadedAnimes.isEmpty, "Should remove all animes from Realm.")
	}

	func testDeleteAnime_ShouldRemoveSpecificAnimeFromRealm() {
		let anime = Anime(id: UUID(), title: "Anime 1", description: "Description 1", image: nil)

		sut.saveSingleAnime(anime: anime)

		sut.deleteAnime(anime: anime)

		let loadedAnimes = sut.loadAllAnimes()
		XCTAssertTrue(loadedAnimes.isEmpty, "Should remove the specific anime from Realm.")
	}

	func testEditAnime_ShouldUpdateExistingAnimeInRealm() {
		var anime = Anime(id: UUID(), title: "Anime 1", description: "Description 1", image: nil)

		sut.saveSingleAnime(anime: anime)

		anime.title = "Updated Anime"
		sut.editAnime(anime: anime)

		let updatedAnime = sut.loadAllAnimes().first { $0.id == anime.id }
		XCTAssertEqual(updatedAnime?.title, "Updated Anime", "The title should be updated in Realm.")
	}
}
