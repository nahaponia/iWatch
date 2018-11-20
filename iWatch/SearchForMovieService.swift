//
//  SearchForMovieService.swift
//  iWatch
//
//  Created by Maxim  on 11/20/18.
//  Copyright © 2018 Maxim. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

protocol SearchMovieProtocol {
    
    func getMovieByID(_ movieID: Int, completed: @escaping (Bool, Movies?) -> Void)
    func searchMovie(by text: String, completed: @escaping (Bool, [Movies]) -> Void)
    
}


class SearchMovies: SearchMovieProtocol {
    
    
    func getMovieByID(_ movieID: Int, completed: @escaping (Bool, Movies?) -> Void) {
        
        let URL = ApiUrls.getInfoAboutMovie + "\(movieID)" + ApiUrls.apiKey
        Alamofire.request(URL, method: .get).responseJSON { response in
            
            var movie: Movies?
            
            guard let response = response.value as? [String: Any] else {
                
                completed(false, movie)
                return
            }
            
            let item = Mapper<Movies>().map(JSON: response)
            movie = item
            completed(true, movie)
            
        }
        
    }
    
    
    func searchMovie(by text: String, completed: @escaping (Bool, [Movies]) -> Void) {
        
        let URL = ApiUrls.searchMovie + text
        
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


