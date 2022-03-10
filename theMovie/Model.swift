//
//  Model.swift
//  theMovie
//
//  Created by Garpepi Aotearoa on 10/03/22.
//

import Foundation

// MARK: - Wrapper
struct Wrapper<T: Decodable>: Decodable {
    let gen: [T]?

    enum CodingKeys: String, CodingKey {
        case gen = "genres"
    }
}

// MARK: - Genre
struct Genre: Codable {
    var id: Int?
    var name: String?
}


// MARK: MOVIEWLIST

// MARK: - WrapperMovie
struct WrapperMovie<T: Decodable>: Decodable {
    let page: Int
    let results: [T]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Movie
struct MovieList: Codable {
    let page: Int?
    let movies: [Movie]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    var adult: Bool?
    var backdropPath: String?
    var genreIDS: [Int]?
    var id: Int?
    var originalLanguage: String?
    var originalTitle, overview: String?
    var popularity: Double?
    var posterPath, releaseDate, title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case fr = "fr"
    case hi = "hi"
    case ja = "ja"
}


// MARK: - MovieReview
struct WrapperMovieReview<T: Decodable>: Decodable {
    var id, page: Int
    var reviews: [T]?
    var totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case id, page
        case reviews = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieReview: Codable {
    var id, page: Int?
    var reviews: [Review]?
    var totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case id, page
        case reviews = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Review
struct Review: Codable {
    var author: String?
    var authorDetails: AuthorDetails?
    var content, createdAt, id, updatedAt: String?
    var url: String?

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

// MARK: - AuthorDetails
struct AuthorDetails: Codable {
    var name, username: String?
    var avatarPath: String?
    var rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
}
