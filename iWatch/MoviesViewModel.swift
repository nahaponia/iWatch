//
//  MoviesViewModel.swift
//  iWatch
//
//  Created by Maxim  on 10/13/18.
//  Copyright © 2018 Maxim. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class MoviesNetworking {
    
    
     func popular(_ page: Int, completed: @escaping(Bool, [Movies]?) -> Void) {
        
        
        let URL = ApiUrls.getPopular + "\(page)"
        var movies = [Movies]()
        
        Alamofire.request(URL, method: .get).responseJSON {
            response in
            
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


class MoviesViewModel {
    
    open var movies: [Movies] = []
    
     func getMovies(page: Int, collectionView: UICollectionView, showError: @escaping () -> Void) {
        print(CFGetRetainCount(moviesModel))
        moviesModel.popular(page) { succes, movie in
            print("Result from server: - \(succes)")
            succes ? self.showMoviesData(mov: movie!, cw: collectionView) : showError()

        }
        
    }
    
    
    func presentAlertController(vc: UIViewController, message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in })
        vc.present(alert, animated: true, completion: nil)
        
    }
    
    
    // Private
    
    private var moviesModel = MoviesNetworking()
//
//    init() {
//        self.moviesModel = MoviesNetworking()
//    }

    private func showMoviesData(mov: [Movies], cw: UICollectionView) {

        movies.append(contentsOf: mov)
        cw.reloadData()

    }
    
    
}






















