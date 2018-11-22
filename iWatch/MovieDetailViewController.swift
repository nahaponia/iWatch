//
//  MovieDetailViewController.swift
//  iWatch
//
//  Created by Maxim  on 9/19/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class MovieDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var movieID: Int = 0
    var indexPath: Int = 0
    
    private var dataStore = DataStore()
    private var storedMovies: MoviesEntity?
    private var viewModel = SearchMoviesViewModel()

    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var filmGenres: UILabel!
    @IBOutlet weak var filmName: UILabel!
    @IBOutlet weak var filmDescription: UILabel!
    @IBOutlet weak var filmRating: UILabel!
    @IBOutlet weak var filmTagline: UILabel!
    @IBOutlet weak var filmPruducedby: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    private func getMovieInfo() {
       
        viewModel.getMovieBy(movieID: movieID, reloadView: {
            
            self.updateMoiveDetails()
            
        }, networkError: {
            
           self.viewModel.presentAlertController(vc: self, message: "Internet connection error")
            
        })
        
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        
        viewModel.isMovieInFavourites(movie: indexPath) ? deleteMovie() : saveMovie()
        
    }
    
    
    private func saveMovie() {
        
        guard let movie = viewModel.movie else { return }
        dataStore.saveMovie(movie, indexPath: indexPath)
        favouriteButton.setImage(UIImage(named: "favourite-filled"), for: .normal)
        
    }
    
    
    private func deleteMovie() {
        
        let movie = dataStore.fetchMovies().filter { $0.currentIndex == indexPath }.first
        dataStore.deleteMovie(movie!)
        favouriteButton.setImage(UIImage(named: "favourite-unfilled"), for: .normal)
        
    }
    
    
    private func updateMoiveDetails() {
        
        let bckgrndImg = viewModel.movie?.backgroundImage ?? ""
        let pstrImg = viewModel.movie?.movieImage ?? ""
        let url = URL(string: ApiUrls.basic + bckgrndImg)
        let url1 = URL(string: ApiUrls.getImage + pstrImg)
            
        backgroundImage.sd_setImage(with: url)
        posterImage.sd_setImage(with: url1)
            
        filmName.text = viewModel.movie?.movieTitle
        filmTagline.text = viewModel.movie?.tagline
        filmDescription.text = viewModel.movie?.movieOverview
        filmRating.text = viewModel.movie?.rating() ?? ""
        
    }
    
    
    private func setupView() {
        
        getMovieInfo()
        tabBarController?.tabBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        viewModel.isMovieInFavourites(movie: indexPath) ? favouriteButton.setImage(UIImage(named: "favourite-filled"), for: .normal) : nil
        
    }
    
        
}


