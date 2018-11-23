//
//  MoviesViewModel.swift
//  iWatch
//
//  Created by Maxim  on 10/13/18.
//  Copyright © 2018 Maxim. All rights reserved.
//

import UIKit

class MoviesViewModel {
    
    
    open var movies: [Movies] = []
    
     func getMovies(page: Int, collectionView: UICollectionView, showError: @escaping () -> Void) { 
        
        moviesModel.popular(page) { [ unowned self ] succes, movie in
            print("Result from server: - \(succes)")
            succes ? self.showMoviesData(mov: movie, cw: collectionView) : showError()

        }
        
    }
    
    
    func presentAlertController(vc: UIViewController, message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in })
        vc.present(alert, animated: true, completion: nil)
        
    }
    
    
    func numberOfRowsInSection() -> Int {
        
        return movies.count
        
    }
    
   
    // Private
    
    
    private var moviesModel =  MoviesNetworking()
    
    
    private func showMoviesData(mov: [Movies], cw: UICollectionView) {

        movies.append(contentsOf: mov)
        cw.reloadData()

    }
    
    
}




