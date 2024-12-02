// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let response = try? JSONDecoder().decode(Response.self, from: jsonData)

import Foundation

// MARK: - Response
struct Response: Codable {
	let data: [Datum]
	let meta: ResponseMeta
	let links: ResponseLinks
}

// MARK: - Datum
struct Datum: Codable {
	let id, type: String
	let links: DatumLinks
	let attributes: Attributes
	let relationships: [String: Relationship]
}

// MARK: - Attributes
struct Attributes: Codable {
	let createdAt, updatedAt, slug, synopsis: String
	let description: String
	let coverImageTopOffset: Int
	let titles: Titles
	let canonicalTitle: String
	let abbreviatedTitles: [String]
	let averageRating: String
	let ratingFrequencies: [String: String]
	let userCount, favoritesCount: Int
	let startDate, endDate: String
	let nextRelease: JSONNull?
	let popularityRank, ratingRank: Int
	let ageRating, ageRatingGuide, subtype, status: String
	let tba: String?
	let posterImage: PosterImage
	let coverImage: CoverImage
	let episodeCount, episodeLength, totalLength: Int
	let youtubeVideoID, showType: String
	let nsfw: Bool

	enum CodingKeys: String, CodingKey {
		case createdAt, updatedAt, slug, synopsis, description, coverImageTopOffset, titles, canonicalTitle, abbreviatedTitles, averageRating, ratingFrequencies, userCount, favoritesCount, startDate, endDate, nextRelease, popularityRank, ratingRank, ageRating, ageRatingGuide, subtype, status, tba, posterImage, coverImage, episodeCount, episodeLength, totalLength
		case youtubeVideoID = "youtubeVideoId"
		case showType, nsfw
	}
}

// MARK: - CoverImage
struct CoverImage: Codable {
	let tiny, large, small: String
	let original: String
	let meta: CoverImageMeta
}

// MARK: - CoverImageMeta
struct CoverImageMeta: Codable {
	let dimensions: Dimensions
}

// MARK: - Dimensions
struct Dimensions: Codable {
	let tiny, large, small: Large
	let medium: Large?
}

// MARK: - Large
struct Large: Codable {
	let width, height: Int
}

// MARK: - PosterImage
struct PosterImage: Codable {
	let tiny, large, small, medium: String
	let original: String
	let meta: CoverImageMeta
}

// MARK: - Titles
struct Titles: Codable {
	let en, enJp, jaJp: String
	let enUs: String?

	enum CodingKeys: String, CodingKey {
		case en
		case enJp = "en_jp"
		case jaJp = "ja_jp"
		case enUs = "en_us"
	}
}

// MARK: - DatumLinks
struct DatumLinks: Codable {
	let linksSelf: String

	enum CodingKeys: String, CodingKey {
		case linksSelf = "self"
	}
}

// MARK: - Relationship
struct Relationship: Codable {
	let links: RelationshipLinks
}

// MARK: - RelationshipLinks
struct RelationshipLinks: Codable {
	let linksSelf, related: String

	enum CodingKeys: String, CodingKey {
		case linksSelf = "self"
		case related
	}
}

// MARK: - ResponseLinks
struct ResponseLinks: Codable {
	let first, next, last: String
}

// MARK: - ResponseMeta
struct ResponseMeta: Codable {
	let count: Int
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

	public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
			return true
	}

	public var hashValue: Int {
			return 0
	}

	public init() {}

	public required init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()
			if !container.decodeNil() {
					throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
			}
	}

	public func encode(to encoder: Encoder) throws {
			var container = encoder.singleValueContainer()
			try container.encodeNil()
	}
}