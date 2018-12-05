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
        
        genresModel.getAllGenres { [weak self] (succes, response) in
            
            guard let self = self else { return }
            
            succes ? self.showAllGenres(response, tw: tableView) : showError()
            
        }
        
    }
    
    
    func getMoviesBySelectedGenre(genre: Int, collectionView: UICollectionView, showError: @escaping () -> Void) {
        
        genresModel.getSelectedGenres(genre) { [weak self] (succes, response) in
            print(response)
            
            guard let self = self else { return }
            
            succes ? self.showMoviesByGenre(movie: response, cw: collectionView) : showError()
            
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
    
    
    func numberOfJenresInSection() -> Int {
    
        return genres.count
    
    }
    
    
    let genresModel: GetMovieGenres
    
    init(model: GetMovieGenres) {
        
        self.genresModel = model
        
    }
    
    
    // Private
    
    
    private func showAllGenres(_ genre: [Genres], tw: UITableView) {
        
        genres = genre
        tw.reloadData()
        
    }
    
    private func showMoviesByGenre(movie: [Movies], cw: UICollectionView) {
        
        movies = movie
        cw.reloadData()
        
    }
    
    
}
