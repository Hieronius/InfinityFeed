import UIKit

/// Protocol for the service to fetch anime from the API data
protocol AnimeFetcherProtocol: AnyObject {
	
	func loadImage(from url: URL) async throws -> UIImage
	func fetchAnimes(from response: Response) async throws -> [Anime]
	
}

/// Implementation of the service to fetch anime from the API data
final class AnimeFetcher: AnimeFetcherProtocol {
	
	// MARK: - Public Methods
	
	/// Specific method to process anime's poster into an image
	func loadImage(from url: URL) async throws -> UIImage {
		let (data, _) = try await URLSession.shared.data(from: url)
		guard let image = UIImage(data: data) else {
			throw URLError(.cannotDecodeContentData)
		}
		return image
	}
	
	/// The main method to process downloaded data into anime objects
	func fetchAnimes(from response: Response) async throws -> [Anime] {
		var animes: [Anime] = []
		
		guard !response.data.isEmpty else { return animes }
		for datum in response.data {
			
			guard let attributes = datum.attributes else { return animes }
			
			let title = attributes.canonicalTitle
			let description = attributes.synopsis
			
			let posterImageURLString = attributes.posterImage.original
			var localImage: UIImage? = nil
			
			if let url = URL(string: posterImageURLString) {
				do {
					let image = try await loadImage(from: url)
					localImage = image
				} catch {
					print("Image loading error: \(error.localizedDescription)")
				}
			}
			
			let anime = Anime(id: UUID(),
							  title: title ?? "Unowned",
							  description: description,
							  image: localImage)
			
			animes.append(anime)
		}
		return animes
	}
}
