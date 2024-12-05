import Foundation
import RealmSwift

/// Protocol for implementation of the manager to work with Realm Data Storage
protocol RealmDataManagerProtocol: AnyObject {

	func saveAllAnimes(animes: [Anime])
	func loadAllAnimes() -> [Anime]
	func deleteAllAnimes()

	func saveSingleAnime(anime: Anime)
	func deleteAnime(anime: Anime)
	func editAnime(anime: Anime)
}

/// Implementation of the manager to work with Realm Data Storage
final class RealmDataManager: RealmDataManagerProtocol {

	// MARK: - Private Properties

	private let realm = try! Realm()

	// MARK: - Public Properties

	/// Save the whole array of cashed animes to the storage
	func saveAllAnimes(animes: [Anime]) {
		let animeRealmObjects = animes.map { anime in
			AnimeRealm(id: anime.id,
					   title: anime.title,
					   discription: anime.description,
					   image: anime.image)
		}
		try! realm.write {
			realm.add(animeRealmObjects)
		}
	}

	/// Method to get all stored animes from the storage
	@discardableResult
	func loadAllAnimes() -> [Anime] {
		let animeRealmObjects = realm.objects(AnimeRealm.self)

		return animeRealmObjects.map { animeRealm in
			Anime(id: animeRealm.id,
				  title: animeRealm.title,
				  description: animeRealm.discription,
				  image: animeRealm.getImage())
		}
	}

	/// Remove all stored animes from the storage
	func deleteAllAnimes() {
		let animes = realm.objects(AnimeRealm.self)
		try! realm.write {
			realm.delete(animes)
		}
	}

	/// Allows to save only a specific anime to the storage
	func saveSingleAnime(anime: Anime) {
		let animeRealm = AnimeRealm(id: anime.id,
									title: anime.title,
									discription: anime.description,
									image: anime.image)
		try! realm.write {
			realm.add(animeRealm)
		}

	}

	/// Delete only specific anime from the storage
	func deleteAnime(anime: Anime) {
		if let objectToDelete = realm.object(ofType: AnimeRealm.self, forPrimaryKey: anime.id) {

			try! realm.write {
				realm.delete(objectToDelete)
			}

		}
	}

	/// Method to change a specific anime inside the storage
	func editAnime(anime: Anime) {
		if let objectToEdit = realm.object(ofType: AnimeRealm.self, forPrimaryKey: anime.id) {

			try! realm.write {

				objectToEdit.title = anime.title
				objectToEdit.discription = anime.description
				if let image = anime.image {
					objectToEdit.imageData = image.jpegData(compressionQuality: 0.8)
				} else {
					objectToEdit.imageData = nil
				}
			}

			try! realm.write {
				realm.add(objectToEdit, update: .modified)
			}
		}
	}
}
