//
//  MovieCollectionViewCell.swift
//  iWatch
//
//  Created by Maxim  on 9/17/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var posterName: UILabel!

    @IBOutlet weak var posterRating: UILabel!
    @IBOutlet weak var posterDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterName.layer.shadowColor = UIColor.black.cgColor
        posterName.layer.shadowOffset = CGSize(width: 0, height: 0)
        posterName.layer.shadowOpacity = 1
        posterName.layer.shadowRadius = 6

        posterRating.layer.shadowColor = UIColor.black.cgColor
        posterRating.layer.shadowOffset = CGSize(width: 0, height: 0)
        posterRating.layer.shadowOpacity = 1
        posterRating.layer.shadowRadius = 6

        posterDescription.layer.shadowColor = UIColor.black.cgColor
        posterDescription.layer.shadowOffset = CGSize(width: 0, height: 0)
        posterDescription.layer.shadowOpacity = 1
        posterDescription.layer.shadowRadius = 6
        
    }

}
