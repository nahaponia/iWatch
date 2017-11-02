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
    
    var movies: [Movies]?
    var storedProducts: [MoviesEntity]?
    
    var currentPage = 1
    var genreID: Int?

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMovies()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scrollToTop()
        currentPage = 1
    }
    
    func getMovies() {
        GetMovies.popular(currentPage, completed: { [weak self] data in
            self?.movies = data!
            self?.collectionView.reloadData()
        })
    }

    func scrollToTop() {
        let delay = 0.1 * Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)) { () in
            let firstRowIndexPath = IndexPath(item: 0, section: 0)
            self.collectionView.scrollToItem(at: firstRowIndexPath, at: .top, animated: true)
        }
    }
    
    func setupView() {
        tabBarController?.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupCell(_ cell: MovieCollectionViewCell, movie: Movies, indexPath: IndexPath) {
        if let movie = movies?[indexPath.row] {
            
            cell.posterRating.text = "\(movie.movieRating!)"
            cell.posterName.text = movie.movieTitle
            cell.posterDescription.text = movie.movieOverview
            
            if let backgroundImage = movie.backgroundImage {
                let url = URL(string: ApiUrls.basic + backgroundImage)!
                cell.posterImage.sd_setImage(with: url ) { (image, error, cache, url) in
                    cell.posterImage.image = image
                }
            }
            
        }
        cell.layer.cornerRadius = 12
    }

}

extension PopularViewController: UICollectionViewDataSource {
    
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let moviesCount = movies?.count {
            let lastItem = moviesCount - 1
            if indexPath.row == lastItem {
                currentPage += 1
                GetMovies.popular(currentPage, completed: { [weak self] movie in
                    for i in movie! {
                        self?.movies?.append(i)
                    }
                    self?.collectionView.reloadData()
                })
            }
        }
    }
    
}

extension PopularViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Popular", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            vc.movieID = movies?[indexPath.row].movieID
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension PopularViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 24, height: 370)
    }
    
}

extension PopularViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
}
