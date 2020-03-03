//
//  Movie+CoreDataProperties.swift
//  MyMovies
//
//  Created by user on 2/17/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var name: String?

}
