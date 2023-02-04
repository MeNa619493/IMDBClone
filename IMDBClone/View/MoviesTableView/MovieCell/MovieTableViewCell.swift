//
//  MovieTableViewCell.swift
//  IMDBClone
//
//  Created by Mina on 03/02/2023.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UIButton!
    @IBOutlet weak var movieDuration: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initView()
    }
    
    func initView() {
        movieYear.titleLabel?.font =  UIFont(name: "Helvetica", size: 8)
        movieYear.layer.cornerRadius = movieYear.frame.height/2
        movieYear.isEnabled = false
        movieImage.layer.cornerRadius = 15
    }

    func configureCell(movie: Movie) {
        movieTitle.text = movie.title
        
        movieYear.setTitle(movie.year, for: .normal)
        movieDuration.text = "1h 47m"
        if let rate = movie.imDBRating {
            movieRating.text = "\(rate)/10 IMDb"
        }
        
        if let url = URL(string: movie.image ?? ""){
            movieImage.kf.setImage(with: url)
        }
    }
    
}
