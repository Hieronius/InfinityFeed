import UIKit

/// Struct to hold an info about each of the specific anime we display on the feed
struct Anime: Hashable {
	
	/// Unique ID
	let id: UUID
	
	/// Name of the anime
	let title: String
	
	/// Description of the anime
	let description: String?
	
	/// Poster image of the anime
	let image: UIImage?
}
