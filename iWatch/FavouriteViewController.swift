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
        
        setupView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchFavouriteMovies()
    }
    
    
    private func setupView() {
        
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    private func fetchFavouriteMovies() {
        
        storedMovie = dataStore.fetchMovies()
        collectionView.reloadData()
        
    }
    

}


extension FavouriteViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return storedMovie.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        cell.setupFromCoreData(cell, indexPath: indexPath, movie: storedMovie[indexPath.row])
        
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
