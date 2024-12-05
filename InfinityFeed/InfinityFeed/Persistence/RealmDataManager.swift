import Foundation
import RealmSwift

protocol RealmDataManagerProtocol: AnyObject {

	func saveAllAnimes(animes: [Anime])
	func loadAllAnimes() -> [Anime]
	func deleteAllAnimes()

	func saveSingleAnime(anime: Anime)
	func deleteAnime(anime: Anime)
	func editAnime(anime: Anime)
}

final class RealmDataManager: RealmDataManagerProtocol {

	private let realm = try! Realm()

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

	func deleteAllAnimes() {
		let animes = realm.objects(AnimeRealm.self)
		try! realm.write {
			realm.delete(animes)
		}
	}

	func saveSingleAnime(anime: Anime) {
		let animeRealm = AnimeRealm(id: anime.id,
									title: anime.title,
									discription: anime.description,
									image: anime.image)
		try! realm.write {
			realm.add(animeRealm)
		}

	}

	func deleteAnime(anime: Anime) {
		if let objectToDelete = realm.object(ofType: AnimeRealm.self, forPrimaryKey: anime.id) {

			try! realm.write {
				realm.delete(objectToDelete)
			}

		}
	}

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
