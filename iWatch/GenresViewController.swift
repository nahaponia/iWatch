//
//  GenresViewController.swift
//  iWatch
//
//  Created by Maxim  on 9/23/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit

class GenresViewController: UIViewController {
    
    private var viewModel = GenresViewModel()
   
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    private func setupView() {
        
        getGenres()
        tableView.backgroundColor = ColorPalette.backgroundBlack
        tableView.separatorColor = UIColor.gray
        
    }
    
    
    private func getGenres() {
      
        viewModel.getGenres(tableView: tableView) {
            
            self.viewModel.presentAlertController(vc: self, message: "Internet connection Error")
            
        }
        
    }
    
}


extension GenresViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("GenreTableViewCell", owner: self, options: nil)?.first as! GenreTableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.genreLabel.text = viewModel.genres[indexPath.row].genre
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.genres.count
        
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
