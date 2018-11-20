//
//  GenresDetailViewController.swift
//  iWatch
//
//  Created by Maxim  on 10/3/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit

class GenresDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    private var viewModel = GenresViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    var genreID: Int = 0

    private func getMoviesByGenre() {
        
        viewModel.getMoviesBySelectedGenre(genre: genreID, collectionView: collectionView) {
            
            self.viewModel.presentAlertController(vc: self, message: "Internet conection error")
            
        }
        
    }
    
    
    private func setupView() {
        
        
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        
        getMoviesByGenre()
        
    }
    
    
    
    fileprivate func setupCell(_ cell: MovieCollectionViewCell, movie: Movies, indexPath: IndexPath) {
        
        cell.layer.cornerRadius = 12
        cell.posterRating.text = "\(movie.movieRating!)"
        cell.posterName.text = movie.movieTitle
        cell.posterDescription.text = movie.movieOverview
        
        let movieImage = movie.backgroundImage ?? ""
        guard let url = URL(string: ApiUrls.basic + movieImage) else  { return }
        
        cell.posterImage.sd_setImage(with: url)
        
    }

    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
   
    
}


extension GenresDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.movies.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        setupCell(cell, movie: viewModel.movies[indexPath.row], indexPath: indexPath)
        
        return cell
        
    }
    
    

}

extension GenresDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = Storyboards.viewController(storyboard: "Popular", controller: "MovieDetailViewController") as! MovieDetailViewController
        vc.movieID = viewModel.movies[indexPath.row].movieID
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


extension GenresDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 24, height: 370)
        
    }
    
}

