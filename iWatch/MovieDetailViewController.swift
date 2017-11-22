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
    private var movie: Movies?
    private var storedMovies: MoviesEntity?
    
    private var dataStore = DataStore()

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMovieInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupView() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
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
        if let movie = movie {
            dataStore.saveMovie(movie)
        }
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        if let storedMovie = storedMovies {
            dataStore.deleteMovie(storedMovie)
        }
    }
    
    private func getMovieInfo() {
        GetMovies.byID(movieID) { [weak self] (movie) in
            self?.movie = movie
            self?.requestMovieInfo()
        }
    }
    
    
    private func requestMovieInfo() {
        
        if let movie = movie {
            
            self.filmName.text = movie.movieTitle
            self.filmTagline.text = movie.tagline
            self.filmDescription.text = movie.movieOverview
            self.filmRating.text = movie.rating() + "/10"
            
            guard let url = URL(string: ApiUrls.basic + movie.backgroundImage) else { return }
            guard let url1 = URL(string: ApiUrls.getImage + movie.movieImage) else { return }
            
            self.backgroundImage.sd_setImage(with: url) { (image, error, cache, url) in
                self.backgroundImage.image = image
            }
            self.posterImage.sd_setImage(with: url1) { (image, error, cache, url) in
                self.posterImage.image = image
            }
        }
        
    }
        
}
