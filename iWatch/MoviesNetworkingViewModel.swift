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
import SDWebImage

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


class MoviesNetworkingModel {
    
    open var movies = [Movies]()
    private var moviesModel = MoviesNetworking()
    
    
    func getMovies(page: Int, collectionView: UICollectionView) {
        
        moviesModel.popular(page) { (succes, movie) in
            
            succes ? self.showMoviesData(mov: movie!, cw: collectionView) : nil
            
        }
        
    }
    
    
     func setupCell(_ cell: MovieCollectionViewCell, indexPath: IndexPath) {
        
        let movie = movies[indexPath.row]
        cell.posterRating.text = movie.rating()
        cell.posterName.text = movie.movieTitle
        cell.posterDescription.text = movie.movieOverview
        
        if let backgroundImage = movie.backgroundImage {
            guard let url = URL(string: ApiUrls.basic + backgroundImage) else { return }
            cell.posterImage.sd_setImage(with: url ) { (image, error, cache, url) in
                cell.posterImage.image = image
            }
        }
        
        cell.layer.cornerRadius = 12
    }
    
    
    private func showMoviesData(mov: [Movies], cw: UICollectionView) {
        
        movies.append(contentsOf: mov)
        cw.reloadData()
        
    }
    
    
}
