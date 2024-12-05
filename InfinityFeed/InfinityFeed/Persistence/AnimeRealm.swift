import UIKit
import RealmSwift

final class AnimeRealm: Object {
	
	@Persisted var id: UUID
	@Persisted var title: String = ""
	@Persisted var discription: String?
	@Persisted var imageData: Data?
	
	convenience init(id: UUID,
					 title: String,
					 discription: String?,
					 image: UIImage?) {
		self.init()
		self.id = id
		self.title = title
		self.discription = discription
		
		if let image = image {
			self.imageData = image.jpegData(compressionQuality: 0.8)
		}
	}
	
	func getImage() -> UIImage? {
		guard let data = imageData else { return UIImage() }
		return UIImage(data: data)
	}
}

