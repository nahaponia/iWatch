//
//  ApiUrls.swift
//  iWatch
//
//  Created by Maxim  on 9/15/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import Foundation

struct ApiUrls {
    
    static let apiKey: String = "?api_key=fbe4e6280f6a460beaad8ebe2bc130ac"
    static let getAllMovies: String = "https://api.themoviedb.org/3/discover/movie"
    static let getInfoAboutMovie: String = "https://api.themoviedb.org/3/movie/"
    static let getImage: String = "https://image.tmdb.org/t/p/w92//"
    static let basic: String = "https://image.tmdb.org/t/p/w780//"
    static let getGenres: String = "https://api.themoviedb.org/3/genre/movie/list"
    static let searchMovie: String = "https://api.themoviedb.org/3/search/movie?api_key=fbe4e6280f6a460beaad8ebe2bc130ac&query="
    
    static let getPopular: String = "https://api.themoviedb.org/3/discover/movie?api_key=fbe4e6280f6a460beaad8ebe2bc130ac&page="
    static let searhByGenres: String = "https://api.themoviedb.org/3/genre/"
    
}
