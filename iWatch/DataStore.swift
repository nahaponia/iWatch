//
//  DataStore.swift
//  iWatch
//
//  Created by Maxim  on 9/28/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import Foundation
import CoreData

final class DataStore: NSObject {
    
    var coreDataManager = CoreDataManager()
    var storedMovies = [MoviesEntity]()
    
    var context = NSManagedObjectContext(
        concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        
    override init() {
        context = coreDataManager.managedObjectContext
    }
    
    func saveMovie(_ movies: Movies) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "MoviesEntity", in: context)
        let movieToSave = MoviesEntity(entity:entityDescription!, insertInto: context)

        movieToSave.setValue(movies.movieImage, forKey: "movieImage")
        movieToSave.setValue(movies.movieTitle, forKey: "movieTitle")
        movieToSave.setValue(movies.movieOverview, forKey: "movieOverview")
        movieToSave.setValue(movies.movieReleaseDate, forKey: "movieReleaseDate")
        movieToSave.setValue(movies.movieRating, forKey: "movieRating")
        movieToSave.setValue(movies.tagline, forKey: "tagline")
        movieToSave.setValue(movies.backgroundImage, forKey: "backgroundImage")
        movieToSave.setValue(movies.movieID, forKey: "movieID")

        do {
            try context.save()
        } catch {
            abort()
        }
    }

    func savedMovies() -> [Movies]? {
        let entityDescription = NSEntityDescription.entity(forEntityName: "MoviesEntity", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDescription
        do {
            let result = try context.fetch(fetchRequest)
            if result.count == 0 {
                return []
            } else {
                storedMovies = result as! [MoviesEntity]
                return convertToMoviesModel()
            }
        } catch let error {
            print("Could not fetch \(error), \(String(describing: error._userInfo))")
            return []
        }

    }
    
    func fetchMovies() -> [MoviesEntity] {
        let entityDescription = NSEntityDescription.entity(forEntityName: "MoviesEntity", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDescription
        do {
            let result = try context.fetch(fetchRequest)
            if result.count == 0 {
                return []
            } else {
                storedMovies = result as! [MoviesEntity]
                return storedMovies
            }
        } catch let error {
            print("Could not fetch \(error), \(String(describing: error._userInfo))")
            return []
        }
    }

    func deleteMovie(_ product: MoviesEntity) {
        do {
            context.delete(product)
            try context.save()
        } catch let error {
            print("Could not fetch \(error), \(String(describing: error._userInfo))")
        }

    }

    // MARK : Helper methods

    func convertToMoviesModel() -> [Movies] {
        var tempArr = [Movies]()
        for prod in storedMovies {
            var movies = Movies()
            movies.backgroundImage = prod.backgroundImage
            movies.tagline = prod.tagline
            movies.movieRating = prod.movieRating
            movies.movieReleaseDate = prod.movieReleaseDate
            movies.movieOverview = prod.movieOverview
            movies.movieTitle = prod.movieTitle
            movies.movieImage = prod.movieImage
            movies.movieID = Int(prod.movieID)
            
            tempArr.append(movies)
        }
        return tempArr
    }

    
}
