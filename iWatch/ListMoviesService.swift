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


protocol PopularMoviesProtocol {
    func popular(_ page: Int, completed: @escaping(Bool, [Movies]) -> Void)
}




class MoviesNetworking: PopularMoviesProtocol {
    
    func popular(_ page: Int, completed: @escaping(Bool, [Movies]) -> Void) {
        
        let URL = ApiUrls.getPopular + "\(page)"
        var movies = [Movies]()
        
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        
        Alamofire.request(URL, method: .get).responseJSON { response in
            
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





