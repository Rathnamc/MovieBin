//
//  Movie+CoreDataProperties.swift
//  
//
//  Created by Christopher Rathnam on 4/21/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Movie {

    @NSManaged var image: NSData?
    @NSManaged var plot: String?
    @NSManaged var rating: String?
    @NSManaged var title: String?

}
