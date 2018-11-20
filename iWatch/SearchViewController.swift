//
//  SearchViewController.swift
//  iWatch
//
//  Created by Maxim  on 9/25/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {
    
    private var viewModel = SearchMoviesViewModel()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewOfset: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    private func setupView() {
        
        tableView.backgroundColor = ColorPalette.backgroundBlack
        searchBar.barTintColor = ColorPalette.backgroundBlack
        tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotificationUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotificationDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    @objc private func handleKeyboardNotificationUp(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            tableViewOfset.constant += keyboardFrame!.height - 35 
        }
        
    }
    
    
    @objc private func handleKeyboardNotificationDown(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            tableViewOfset.constant -= keyboardFrame!.height
        }
        
    }
    
    
    fileprivate func setupCell(_ cell: SearchTableViewCell, movie: Movies, indexPath: IndexPath) {
        
        cell.moveName.text = viewModel.movies[indexPath.row].movieTitle
        cell.movieYear.text = viewModel.movies[indexPath.row].movieReleaseDate
        cell.movieRating.text = "\(viewModel.movies[indexPath.row].movieRating!)/10"
        
        let apiURL = viewModel.movies[indexPath.row].backgroundImage ?? ""
        let url = URL(string: ApiUrls.basic + apiURL)
        cell.movieImage.sd_setImage(with: url )
        
    }
    
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SearchTableViewCell", owner: self, options: nil)?.first as! SearchTableViewCell
        cell.backgroundColor = UIColor.clear

        setupCell(cell, movie: viewModel.movies[indexPath.row], indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.movies.count
        
    }
    

}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 108
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}


extension SearchViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        viewModel.searchMovieBy(text: searchBar.text!, tableView: tableView) {
            
            self.viewModel.presentAlertController(vc: self, message: "Internet Connection Error")
            
        }

    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
    }
    
    
}








