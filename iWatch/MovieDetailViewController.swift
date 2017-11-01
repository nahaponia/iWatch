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
    var movie: Movies!
    var storedMovies: MoviesEntity!
    
    var dataStore = DataStore()

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
    
    func setupView() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        if let indexPath = indexPath {
            storedMovies = dataStore.fetchMovies()[indexPath]
        }
    }

    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMovieInfo()
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
    
    func getMovieInfo() {
        GetMovies.byID(movieID) { [weak self] (movie) in
            self?.movie = movie!
            
            let rating: String = {
                let rating = String(describing: movie!.movieRating!)
                return rating
            }()
            
            self?.filmName.text = movie?.movieTitle
            self?.filmTagline.text = movie?.tagline
            self?.filmDescription.text = movie?.movieOverview
            self?.filmRating.text = rating + "/10"
            
            let url = URL(string: ApiUrls.basic + (movie?.backgroundImage)!)
            let url1 = URL(string: ApiUrls.getImage + (movie?.movieImage)!)
            
            self?.backgroundImage.sd_setImage(with: url) { (image, error, cache, url) in
                self?.backgroundImage.image = image
            }
            self?.posterImage.sd_setImage(with: url1) { (image, error, cache, url) in
                self?.posterImage.image = image
            }
            
        }

    }
    
    
}
