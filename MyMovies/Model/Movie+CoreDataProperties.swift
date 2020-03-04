//
//  Movie+CoreDataProperties.swift
//  MyMovies
//
//  Created by user on 3/4/20.
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
    @NSManaged public var genre: String?
    @NSManaged public var details: String?
    @NSManaged public var rating: Double
    @NSManaged public var date: Date?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var wasWatched: Bool

}
