//
//  MoviesByGenreService.swift
//  iWatch
//
//  Created by Maxim  on 11/20/18.
//  Copyright © 2018 Maxim. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire


protocol GetMovieGenresProtocol {
    
    func getAllGenres(completed: @escaping (Bool, [Genres]) -> Void)
    func getSelectedGenres(_ genre: Int, completed: @escaping (Bool, [Movies]) -> Void)
    
}


class GetMovieGenres: GetMovieGenresProtocol {
    
    
    func getAllGenres(completed: @escaping (Bool, [Genres]) -> Void) {
        
        let URL = ApiUrls.getGenres + ApiUrls.apiKey
        
        Alamofire.request(URL, method: .get).responseJSON { response in
            
            var genre = [Genres]()
            
            guard let response = response.value as? [String: Any], let genres = response["genres"] as? [Any] else {
                completed(false, genre)
                return
            }
            
            genres.forEach({ (result) in
                let item = Mapper<Genres>().map(JSON: result as! [String : Any])
                genre.append(item!)
            })
            completed(true, genre)
            
        }
        
    }
    
    
    func getSelectedGenres(_ genre: Int, completed: @escaping (Bool, [Movies]) -> Void) {
        let URL = ApiUrls.searhByGenres + "\(genre)" + "/movies" + ApiUrls.apiKey
        
        Alamofire.request(URL, method: .get).responseJSON { response in
            
            var movies = [Movies]()
            
            guard let json = response.value as? [String: Any], let results = json["results"] as? [Any] else {
                
                completed(false, movies)
                return
            }
            
            results.forEach({ (result) in
                let item = Mapper<Movies>().map(JSON: result as! [String : Any])
                movies.append(item!)
            })
            completed(true, movies)
            
        }
        
    }
    
    
}



