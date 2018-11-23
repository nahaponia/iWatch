//
//  SearchTableViewCell.swift
//  iWatch
//
//  Created by Maxim  on 9/25/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var moveName: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
    }
    
    
    func setup(_ cell: SearchTableViewCell, indexPath: IndexPath, movie: Movies) {
        
        cell.moveName.text = movie.movieTitle
        cell.movieYear.text = movie.movieReleaseDate
        cell.movieRating.text = "\(movie.movieRating ?? 0)/10"
        
        let apiURL = movie.backgroundImage ?? ""
        let url = URL(string: ApiUrls.basic + apiURL)
        cell.movieImage.sd_setImage(with: url )
        
    }
    
    
}
