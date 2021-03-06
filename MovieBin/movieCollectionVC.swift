//
//  ViewController.swift
//  MovieBin
//
//  Created by Christopher Rathnam on 4/11/16.
//  Copyright © 2016 Christopher Rathnam. All rights reserved.
//

import UIKit
import CoreData
import Alamofire


class movieCollectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies = [Movie]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.splitViewController?.preferredDisplayMode = .AllVisible
        self.splitViewController?.delegate = self
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        fetchAndSetData()
        tableView.reloadData()
    }
    
    
    //Function sets and stores data
    func fetchAndSetData() {
        //Grab App Delegate
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        //create Stratch Pad
        let context = app.managedObjectContext
        //Make a fetch request for data
        let fetchRequest = NSFetchRequest(entityName: "Movie")
        
        //Check to see if Fetch was successful
        do {
            let result = try context.executeFetchRequest(fetchRequest)
            //store fetched data in empty array
            self.movies = result as! [Movie]
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as? MovieCell {
            
            //Gets movie from current cell
            let movie = movies[indexPath.row]
            cell.configureCell(movie)
            return cell
        } else {
            return MovieCell()
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let movie : Movie!
        movie = movies[indexPath.row]
        performSegueWithIdentifier("movieDetailVCSegue", sender: movie)
    }
 
    //MARK: BUG with in editing function.
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let movieItem = movies[indexPath.row]
        
        
        //ADD Core Data Edit Ability
        
        
        let Edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            var movie: Movie!
            movie = self.movies[indexPath.row]
            
            movie.setValue(movie.title, forKey: "title")
            movie.setValue(movie.plot, forKey: "plot")
            movie.setValue(movie.rating, forKey: "rating")
            
           self.performSegueWithIdentifier("editMovieSegue", sender: movie)
        
        }
        
        Edit.backgroundColor = UIColor(red:0.341, green:0.831, blue:0.918, alpha:1.00)
        
        let Delete = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
          
            
            context.deleteObject(movieItem)
            print ("Delete Object")
            
            do {
                try context.save()
            } catch {
                print("Could not delete cell")
            }
    
            self.fetchAndSetData()
            self.tableView.reloadData()
    
        }
        
        Delete.backgroundColor = UIColor(red:1.000, green:0.267, blue:0.318, alpha:1.00)
        return [Delete, Edit]
    }
 
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieDetailVCSegue" {
            if let detailsVC = segue.destinationViewController as? movieDetailVC {
                if let movie = sender as? Movie {
                    detailsVC.movie = movie
                }
            }
        }
        if segue.identifier == "editMovieSegue" {
            if let editVC = segue.destinationViewController as? editMovieVC {
                if let movie = sender as? Movie {
                    editVC.movie = movie
                }
            }
        }
    }
}

