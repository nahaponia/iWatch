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
    
    
    var movieID: Int!
    var indexPath: Int?
    
    private var dataStore = DataStore()
    private var storedMovies: MoviesEntity?
    private var viewModel = SearchMoviesViewModel()

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
    
    
    private func setupView() {
       
        getMovieInfo()
        tabBarController?.tabBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        if let indexPath = indexPath {
            storedMovies = dataStore.fetchMovies()[indexPath]
        }
        
    }

    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        
        if let movie = viewModel.movie {
            dataStore.saveMovie(movie)
        }
        
    }
    
    
    @IBAction func deleteButton(_ sender: UIButton) {
        
        if let storedMovie = storedMovies {
            dataStore.deleteMovie(storedMovie)
        }
        
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
    
        
}


