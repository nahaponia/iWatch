//
//  GenresViewController.swift
//  iWatch
//
//  Created by Maxim  on 9/23/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit

class GenresViewController: UIViewController {
    
    fileprivate var genres: [Genres]?
   
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getGenres()
    }
    
    private func setupView() {
        tableView.backgroundColor = ColorPalette.backgroundBlack
        tableView.separatorColor = UIColor.gray
    }
    
    private func getGenres() {
        GetMovies.getGenres { [weak self] genres in
            self?.genres = genres
            self?.tableView.reloadData()
        }
    }
    
}

extension GenresViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("GenreTableViewCell", owner: self, options: nil)?.first as! GenreTableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.genreLabel.text = genres?[indexPath.row].genre
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let genre = genres { return genre.count } else { return 1 }
    }
    
}

extension GenresViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Genre", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "GenresDetailViewController") as? GenresDetailViewController {
            vc.genreID = (genres?[indexPath.row].genreID)!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
