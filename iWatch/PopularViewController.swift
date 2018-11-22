//
//  PopularViewController.swift
//  iWatch
//
//  Created by Maxim  on 9/28/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit


class PopularViewController: UIViewController  {
    
    
    var currentPage = 1

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy private var viewModel: MoviesViewModel = {
        return MoviesViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        networkRequest()
    }
    
    
    private func networkRequest() {
       
        guard viewModel.movies.count != 0 else {
            
            viewModel.getMovies(page: currentPage, collectionView: collectionView) {
                self.viewModel.presentAlertController(vc: self, message: "Internet connection error")
            }
            
            return
        }
        
    }
    
    
    private func setupView() {
        
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        self.navigationController?.navigationBar.isHidden = true
        
        
    }
    
    private func setupCell(_ cell: MovieCollectionViewCell, indexPath: IndexPath) {
        
        let movie = viewModel.movies[indexPath.row]
        cell.posterRating.text = movie.rating()
        cell.posterName.text = movie.movieTitle
        cell.posterDescription.text = movie.movieOverview

        if let backgroundImage = movie.backgroundImage {
            guard let url = URL(string: ApiUrls.basic + backgroundImage) else { return }
            cell.posterImage.sd_setImage(with: url)
        }
        
        cell.layer.cornerRadius = 12
        
    }
    

}





extension PopularViewController: UICollectionViewDataSource {
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.movies.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        setupCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let lastItem = viewModel.movies.count  - 4

        if indexPath.row == lastItem {

            currentPage += 1
            viewModel.getMovies(page: currentPage, collectionView: collectionView, showError: {
                 self.viewModel.presentAlertController(vc: self, message: "Internet connection error")
            })
        }
        
    }
    
    
}


extension PopularViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let vc = Storyboards.viewController(storyboard: "Popular", controller: "MovieDetailViewController") as! MovieDetailViewController
        vc.movieID = viewModel.movies[indexPath.row].movieID
        vc.indexPath = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


extension PopularViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 24, height: 370)
        
    }
    
}


