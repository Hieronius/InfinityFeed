import XCTest
import @testable InfinityFeed

final class MockRealmDataManager: RealmDataManagerProtocol {
	var animesToReturn: [Anime] = []

	func saveAllAnimes(animes: [Anime]) {}

	func loadAllAnimes() -> [Anime] {
		return animesToReturn
	}

	func deleteAllAnimes() {}

	func saveSingleAnime(anime: Anime) {}

	func deleteAnime(anime: Anime) {}

	func editAnime(anime: Anime) {}
}
