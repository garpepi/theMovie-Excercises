//
//  APIManager.swift
//  theMovie
//
//  Created by Garpepi Aotearoa on 10/03/22.
//

import UIKit

enum typeAPI {
    case genres
    case movieList
    case movieReview
}

// MARK: - GenreResource
struct GenreResource: APIResource {
    var page: Int?
    typealias ModelType = Genre
    var id: Int?
    let apiType:typeAPI = .genres
    
    var methodPath: String {
        return "/3/genre/movie/list"
    }

    var filter: String? {
        id != nil ? "!9_bDDxJY5" : nil
    }
}

struct MoviesResource: APIResource {
    var page: Int?
    typealias ModelType = Movie
    var genre: String?
    let apiType:typeAPI = .movieList

    var methodPath: String {
        return "/3/discover/movie"
    }

    var filter: String? {
        genre != nil ? self.genre : nil
    }
}

struct MoviesReviewResource: APIResource {
    var page: Int?
    typealias ModelType = Review 
    var id: String
    let apiType:typeAPI = .movieReview

    var methodPath: String {
        return "/3/movie/"+id+"/reviews"
    }

    var filter: String?
}
