//
//  GenresViewController.swift
//  iWatch
//
//  Created by Maxim  on 9/23/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit

class GenresViewController: UIViewController {
    
    
    private let identifier = CellIdentifiers.TableView.GenreTableViewCell
    
    private let getMovieGenres = GetMovieGenres()

    lazy private var viewModel: GenresViewModel = {
        return GenresViewModel(model: getMovieGenres)
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    private func setupView() {
        
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
       
        view.backgroundColor = ColorPalette.backgroundBlack
        tableView.backgroundColor = ColorPalette.backgroundBlack
        tableView.separatorColor = UIColor.gray
        getGenres()
        
    }
    
    
    private func getGenres() {
      
        viewModel.getGenres(tableView: tableView) {
            
            self.viewModel.presentAlertController(vc: self, message: "Internet connection Error")
            
        }
        
    }
    
}


extension GenresViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? GenreTableViewCell else { return UITableViewCell() }

        
        cell.backgroundColor = UIColor.clear
        cell.genreLabel.text = viewModel.genres[indexPath.row].genre
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.numberOfJenresInSection()

    }
    
    
}


extension GenresViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = Storyboards.viewController(storyboard: "Genre", controller: "GenresDetailViewController") as! GenresDetailViewController
        vc.genreID = (viewModel.genres[indexPath.row].genreID)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
