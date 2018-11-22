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
    
    
    var storedMovie = [MoviesEntity]()
    var dataStore = DataStore()

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    
    private func setupView() {
        storedMovie = dataStore.fetchMovies()
        collectionView.reloadData()
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    fileprivate func setupCell(_ cell: MovieCollectionViewCell, movie: MoviesEntity, indexPath: IndexPath) {
        
        let movie = storedMovie[indexPath.row]
            
        cell.posterRating.text = "\(movie.movieRating)"
        cell.posterName.text = movie.movieTitle
        cell.posterDescription.text = movie.movieOverview
        let image = movie.backgroundImage ?? ""
        let url = URL(string: ApiUrls.basic + image)
        cell.posterImage.sd_setImage(with: url )
        cell.layer.cornerRadius = 12
        
    }
    

}


extension FavouriteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return storedMovie.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie = storedMovie[indexPath.row]
        setupCell(cell, movie: movie, indexPath: indexPath)
        
        return cell
    }
}


extension FavouriteViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = Storyboards.viewController(storyboard: "Popular", controller: "MovieDetailViewController") as! MovieDetailViewController
        vc.movieID = Int(storedMovie[indexPath.row].movieID)
        vc.indexPath = Int(storedMovie[indexPath.row].currentIndex)
        navigationController?.pushViewController(vc, animated: true)
            
    }
    
}


extension FavouriteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 24, height: 370)
        
    }
    
}
