//
//  GetListMovies.swift
//  iWatch
//
//  Created by Maxim  on 9/15/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class GetMovies {
    
    class func popular(_ page: Int, completed: @escaping ([Movies]?) -> Void) {
        let URL = ApiUrls.getPopular + "\(page)"
       
        Alamofire.request(URL, method: .get).responseJSON {
            response in
            var movies = [Movies]()
            if let response = response.value as? [String: Any] {
                if let results = response["results"] as? [Any] {
                    results.forEach({ (result) in
                        let item = Mapper<Movies>().map(JSON: result as! [String : Any])
                        movies.append(item!)
                    })
                    completed(movies)
                }
            }
        }
    }
    
    
    class func byID(_ movieID: Int, completed: @escaping (Movies?) -> Void) {
        let URL = ApiUrls.getInfoAboutMovie + "\(movieID)" + ApiUrls.apiKey
        Alamofire.request(URL, method: .get).responseJSON {
            response in
            var movie: Movies?
            
            if let response = response.value as? [String: Any] {
                let item = Mapper<Movies>().map(JSON: response )
                movie = item
                completed(movie)
            }
        }
    }
    
    //MARK: - Movie Genres

    class func getGenres(completed: @escaping ([Genres]?) -> Void) {
        let URL = ApiUrls.getGenres + ApiUrls.apiKey
        Alamofire.request(URL, method: .get).responseJSON {
            response in
            var genre = [Genres]()
            
            if let response = response.value as? [String: Any] {
                if let resp = response["genres"] as? [Any] {
                    resp.forEach({ (result) in
                        let item = Mapper<Genres>().map(JSON: result as! [String : Any])
                        genre.append(item!)
                    })
                    completed(genre)
                }
            }
        }
    }
    
    //MARK: - Search Movies
    
    class func searchFor(_ searchText: String, completed: @escaping ([Movies]?) -> Void) {
        let URL = ApiUrls.searchMovie + searchText
        Alamofire.request(URL, method: .get).responseJSON {
            response in
            var movies = [Movies]()
            if let results = response.value as? [String: Any] {
                if let result = results["results"] as? [Any] {
                    result.forEach({ (result) in
                        let item = Mapper<Movies>().map(JSON: result as! [String : Any])
                        movies.append(item!)
                    })
                    completed(movies)
                }
            }
        }
    }
    
    //MARK: - Search by genres
    
    class func byGenres(_ genre: Int, completed: @escaping ([Movies]?) -> Void) {
        let URL = ApiUrls.searhByGenres + "\(genre)" + "/movies" + ApiUrls.apiKey
        
        Alamofire.request(URL, method: .get).responseJSON {
            response in
            var movies = [Movies]()
            if let results = response.value as? [String: Any] {
                if let result = results["results"] as? [Any] {
                    result.forEach({ (result) in
                        let item = Mapper<Movies>().map(JSON: result as! [String : Any])
                        movies.append(item!)
                    })
                    completed(movies)
                }
            }
        }
    }

    
}








