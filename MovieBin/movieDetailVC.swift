//
//  movieDetailVC.swift
//  MovieBin
//
//  Created by Christopher Rathnam on 4/18/16.
//  Copyright © 2016 Christopher Rathnam. All rights reserved.
//

import UIKit

class movieDetailVC: UIViewController {

    var movie = Movie()
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieDescLbl: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLbl.text = movie.title
       
    }

    
}
