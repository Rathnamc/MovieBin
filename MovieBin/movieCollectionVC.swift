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
        
        let move : Movie!
        move = movies[indexPath.row]
        performSegueWithIdentifier("movieDetailVCSegue", sender: move)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieDetailVCSegue" {
            if let detailsVC = segue.destinationViewController as? movieDetailVC {
                if let move = sender as? Movie {
                    detailsVC.movie = move
                }
            }
        }
    }
    
    
}

