//
//  SearchViewController.swift
//  iWatch
//
//  Created by Maxim  on 9/25/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var result: [Movies]?
    var text: String?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableViewOfset: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = ColorPalette.backgroundBlack
        searchBar.barTintColor = ColorPalette.backgroundBlack
        tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification1), name: .UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            tableViewOfset.constant += keyboardFrame!.height - 35 
        }
    }
    
    func handleKeyboardNotification1(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            tableViewOfset.constant -= keyboardFrame!.height
        }
    }
    
    func setupCell(_ cell: SearchTableViewCell, movie: Movies, indexPath: IndexPath) {
        
        if let results = result?[indexPath.row] {
            
            cell.moveName.text = results.movieTitle
            cell.movieYear.text = results.movieReleaseDate
            cell.movieRating.text = "\(results.movieRating!)/10"
            
            if let backgroundImage = results.backgroundImage {
                let url = URL(string: ApiUrls.basic + backgroundImage)!
                cell.movieImage.sd_setImage(with: url ) { (image, error, cache, url) in
                    cell.movieImage.image = image
                }
            }
            
        }
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SearchTableViewCell", owner: self, options: nil)?.first as! SearchTableViewCell
        cell.backgroundColor = UIColor.clear

        if let result = result?[indexPath.row] {
            setupCell(cell, movie: result, indexPath: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let result = result { return result.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }

}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        GetMovies.searchFor(searchBar.text!) { [weak self] results in
            self?.result = results
            self?.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
