//
//  PopularViewController.swift
//  iWatch
//
//  Created by Maxim  on 9/28/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit


class PopularViewController: UIViewController  {
    
    
    private var currentPage = 1
    private let identifier = CellIdentifiers.CollectionView.MovieCollectionViewCell
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let moviesNetworking = MoviesNetworking()
    
    lazy private var viewModel: MoviesViewModel = {
        return MoviesViewModel(moviesModel: moviesNetworking)
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    
    }
    
    
    private func networkRequest() {
        
        viewModel.getMovies(page: currentPage, collectionView: collectionView) {
            self.viewModel.presentAlertController(vc: self, message: "Internet connection error")
        }
        
    }
    
    
    
    
    private func setupView() {
        
        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        self.navigationController?.navigationBar.isHidden = true
        
        networkRequest()
        
    }
    

}


extension PopularViewController: UICollectionViewDataSource {
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfRowsInSection()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MovieCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        
        cell.setup(indexPath: indexPath, movie: viewModel.movies[indexPath.row])
        
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
        
        
        vc.movieID = self.viewModel.movies[indexPath.row].movieID
        vc.indexPath = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


extension PopularViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 24, height: 370)
        
    }
    
}


