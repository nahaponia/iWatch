//
//  PopularViewController.swift
//  iWatch
//
//  Created by Maxim  on 9/28/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit

protocol GetMoviesByGenre: class {
    
}

class PopularViewController: UIViewController {
    
    var currentPage = 1

    @IBOutlet weak var collectionView: UICollectionView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private var networkingModel = MoviesNetworkingModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print()
        networkingModel.getMovies(page: currentPage, collectionView: collectionView)
    }
    
    
    private func scrollToTop() {
        let delay = 0.1 * Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)) { () in
            let firstRowIndexPath = IndexPath(item: 0, section: 0)
            self.collectionView.scrollToItem(at: firstRowIndexPath, at: .top, animated: true)
        }
    }
    
    
    private func setupView() {
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        self.navigationController?.navigationBar.isHidden = true
    }
    

}

extension PopularViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return networkingModel.movies.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        networkingModel.setupCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let lastItem = networkingModel.movies.count - 4
        if indexPath.row == lastItem {
            currentPage += 1
            networkingModel.getMovies(page: currentPage, collectionView: collectionView)
        }
        
    }
    
}


extension PopularViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Popular", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            
            vc.movieID = networkingModel.movies[indexPath.row].movieID
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}


extension PopularViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 24, height: 370)
        
    }
    
}


