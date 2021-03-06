//
//  SearchMoviesViewModel.swift
//  iWatch
//
//  Created by Maxim  on 11/20/18.
//  Copyright © 2018 Maxim. All rights reserved.
//

import UIKit


class SearchMoviesViewModel {

    
    open var movie: Movies?
    open var movies: [Movies] = []
    
    
    func getMovieBy(movieID: Int, reloadView: @escaping () -> Void, networkError: @escaping () -> Void) {
        
        moviesModel.getMovieByID(movieID) { (succes, response) in
            
            guard succes else {
                networkError()
                return
            }
            
            self.movie = response!
            reloadView()
            
        }
        
    }
    
    
    func searchMovieBy(text: String, tableView: UITableView, showError: @escaping () -> Void) {
        
        moviesModel.searchMovie(by: text) { [unowned self] (succes, response) in
            
            succes ? self.reloadTableView(tw: tableView, mov: response) : showError()
            
        }
        
    }
    
    
    func presentAlertController(vc: UIViewController, message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in })
        vc.present(alert, animated: true, completion: nil)
        
    }
    
    
    func isMovieInFavourites(movie indexPath: Int) -> Bool {
        
        let mov = dataStore.fetchMovies().filter { $0.currentIndex == indexPath }.first?.isFavourite
        
        guard mov != nil else { return false }
        
        return true
        
    }
    
    
    let moviesModel: SearchMovies
    
    init(moviesModel: SearchMovies) {
        
        self.moviesModel = moviesModel
        
    }
    
    
    // Private
    
    
    private var dataStore = DataStore()
    
    private func reloadTableView(tw: UITableView, mov: [Movies]) {
        
        movies = mov
        tw.reloadData()
        
    }
    
    
}
