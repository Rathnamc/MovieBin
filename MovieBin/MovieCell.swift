//
//  MovieCell.swift
//  MovieBin
//
//  Created by Christopher Rathnam on 4/11/16.
//  Copyright © 2016 Christopher Rathnam. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var moviePlot: UILabel!
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(movie: Movie) {
        movieTitle.text = movie.title
        movieRating.text = movie.rating
        moviePlot.text = movie.plot
        movieImage.image = movie.getMovieImage()
        
    }

}
