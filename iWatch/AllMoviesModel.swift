//
//  AllMoviesModel.swift
//  iWatch
//
//  Created by Maxim  on 9/15/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import Foundation
import ObjectMapper

struct Movies: Mappable {
    
    var movieID: Int!
    var movieTitle: String!
    var movieRating: Double!
    var movieImage: String!
    var backgroundImage: String?
    var movieOverview: String!
    var tagline: String!
    var movieReleaseDate: String!
    var companies: [Companies]?
    
    mutating func mapping(map: Map) {
        movieID <- map["id"]
        movieTitle <- map["original_title"]
        movieRating <- map["vote_average"]
        movieImage <- map["poster_path"]
        backgroundImage <- map["backdrop_path"]
        movieOverview <- map["overview"]
        tagline <- map["tagline"]
        movieReleaseDate <- map["release_date"]
        companies <- map["production_companies"]
    }
    
    func rating() -> String {
        let rating = String(movieRating)
        return rating
    }
    
    
    init?(map: Map) {
        
    }
    
    
}

struct Companies: Mappable {
    
    var productedBy: String!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        productedBy <- map["name"]
    }
}


//MARK: Genres

struct Genres: Mappable {
    var genre: String!
    var genreID: Int!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        genre <- map["name"]
        genreID <- map["id"]
    }
}
