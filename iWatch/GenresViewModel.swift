//
//  GenresViewModel.swift
//  iWatch
//
//  Created by Maxim  on 11/20/18.
//  Copyright © 2018 Maxim. All rights reserved.
//

import UIKit


class GenresViewModel {
    
    
    open var genres: [Genres] = []
    open var movies: [Movies] = []
    
    func getGenres(tableView: UITableView, showError: @escaping () -> Void) {
        
        genresModel.getAllGenres { [unowned self] (succes, response) in
            
            succes ? self.showAllGenres(response, tw: tableView) : showError()
            
        }
        
    }
    
    
    func getMoviesBySelectedGenre(genre: Int, collectionView: UICollectionView, showError: @escaping () -> Void) {
        
        genresModel.getSelectedGenres(genre) { [unowned self] (succes, response) in
            
            succes ? self.showMoviesByGenre(movie: response, cw: collectionView) : showError()
            
        }
        
    }
    
    
    func presentAlertController(vc: UIViewController, message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in })
        vc.present(alert, animated: true, completion: nil)
        
    }
    
    
    // Private
    
    private var genresModel = GetMovieGenres()
    
    private func showAllGenres(_ genre: [Genres], tw: UITableView) {
        
        genres = genre
        tw.reloadData()
        
    }
    
    private func showMoviesByGenre(movie: [Movies], cw: UICollectionView) {
        
        movies = movie
        cw.reloadData()
        
    }
    
    
}
