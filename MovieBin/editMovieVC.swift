//
//  editMovieVC.swift
//  MovieBin
//
//  Created by Christopher Rathnam on 4/21/16.
//  Copyright © 2016 Christopher Rathnam. All rights reserved.
//


import UIKit
import Alamofire
import CoreData

class editMovieVC: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var searchMovie: UITextField!
    @IBOutlet weak var moviePosterImg: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var ratingField: UITextField!
    @IBOutlet weak var plotField: UITextField!
    @IBOutlet weak var addMovieBtn: UIButton!
    
    var movie: Movie!
    
    
    var userInput: String?
    var finalInput: String!
    
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        moviePosterImg.layer.cornerRadius = 5.0
        moviePosterImg.clipsToBounds = true
        searchMovie.delegate = self
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        moviePosterImg.image = image
    }
    
    
    
    @IBAction func addMovieImgPressed(sender: AnyObject) {
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func editMovieBtnPressed(sender: AnyObject) {
        
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Movie")
        
        do {
            try context.executeRequest(fetchRequest)
            print("WeGet Here")
            movie.title = titleField.text
            movie.plot = plotField.text
            movie.rating = ratingField.text
            movie.setMovieImage(moviePosterImg.image!)
            
            do {
                try context.save()
            } catch {
                print("Data Could Not be saved")
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        loadUserData()
        return true
    }
    
    func loadUserData() {
        if let input = searchMovie.text {
            userInput = input
            finalInput = userInput?.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            searchMovie.text = ""
            searchMovie.resignFirstResponder()
        }
        
        downloadMovieData()
    }
    
    
    
    func downloadMovieData() {
        
        
        if searchMovie != nil {
            
            
            let url = NSURL(string: "http://www.omdbapi.com/?t=\(finalInput)&y=&plot=short&r=json")!
            
            Alamofire.request(.GET, url).responseJSON { response  in
                let result = response.result
                
                
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    
                    if let title = dict["Title"] as? String, let rating = dict["imdbRating"] as? String, let plot = dict["Plot"] as? String, let path = dict["Poster"] as? String {
                        print(title)
                        print(rating)
                        print(path)
                        print(plot)
                        
                        let nsurl = NSURL(string: path)!
                        if let data = NSData(contentsOfURL: nsurl) {
                            let img = UIImage(data: data)
                            self.moviePosterImg.image = img
                        }
                        
                        self.titleField.text = title
                        self.ratingField.text = rating
                        self.plotField.text = plot
                    }
                }
            }
        }
    }
    
}

