//
//  GenresDetailViewController.swift
//  iWatch
//
//  Created by Maxim  on 10/3/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit

class GenresDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var movies: [Movies]?
    var genreID: Int = 0

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetMovies.byGenres(genreID) { [weak self] movies in
            self?.movies = movies
            self?.collectionView.reloadData()
        }
    }
    
    func setupView() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func setupCell(_ cell: MovieCollectionViewCell, movie: Movies, indexPath: IndexPath) {
        if let movie = movies?[indexPath.row] {
            
            cell.posterRating.text = "\(movie.movieRating!)"
            cell.posterName.text = movie.movieTitle
            cell.posterDescription.text = movie.movieOverview
            
            if let url = URL(string: ApiUrls.basic + movie.backgroundImage) {
                cell.posterImage.sd_setImage(with: url ) { (image, error, cache, url) in
                    cell.posterImage.image = image
                }
            }
        }
        cell.layer.cornerRadius = 12
    }

}

extension GenresDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movies = movies { return movies.count } else { return 0 }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        if let movie = movies?[indexPath.row] {
            setupCell(cell, movie: movie, indexPath: indexPath)
        }
        
        return cell
    }

}

extension GenresDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 24, height: 370)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
}
