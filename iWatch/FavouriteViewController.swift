//
//  FavouriteViewController.swift
//  iWatch
//
//  Created by Maxim  on 9/28/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController {
    
    var movies: [Movies]?
    var storedMovie: [MoviesEntity]?
    var dataStore = DataStore()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storedMovie = dataStore.fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        storedMovie = dataStore.fetchMovies()
    }
    
    private func setupView() {
        movies = dataStore.savedMovies()
        collectionView.reloadData()
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        self.navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func setupCell(_ cell: MovieCollectionViewCell, movie: MoviesEntity, indexPath: IndexPath) {
        if let movie = storedMovie?[indexPath.row] {
            
            cell.posterRating.text = "\(movie.movieRating)"
            cell.posterName.text = movie.movieTitle
            cell.posterDescription.text = movie.movieOverview
            
            let url = URL(string: ApiUrls.basic + movie.backgroundImage!)
            cell.posterImage.sd_setImage(with: url ) { (image, error, cache, url) in
            cell.posterImage.image = image
            }
            
        }
        cell.layer.cornerRadius = 12
    }

}

extension FavouriteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movies = movies { return movies.count } else { return 0 }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        if let movie = storedMovie?[indexPath.row] {
            setupCell(cell, movie: movie, indexPath: indexPath)
        }
        
        return cell
    }
}

extension FavouriteViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Popular", bundle: nil)

        if let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            vc.movieID = movies?[indexPath.row].movieID
            vc.indexPath = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension FavouriteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 24, height: 370)
    }
    
}
