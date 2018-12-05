//
//  SearchViewController.swift
//  iWatch
//
//  Created by Maxim  on 9/25/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {
    
    private let identifier = CellIdentifiers.TableView.SearchTableViewCell
    
    private let searchMovie = SearchMovies()
    
    lazy private var viewModel: SearchMoviesViewModel = {
        return SearchMoviesViewModel(moviesModel: searchMovie)
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewOfset: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    

    private func setupView() {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = ColorPalette.backgroundBlack
        
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        
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
    
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        
        cell.setup(indexPath: indexPath, movie: viewModel.movies[indexPath.row])
        
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
        
        viewModel.searchMovieBy(text: searchBar.text!, tableView: tableView) { }

    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
    }
    
    
}








