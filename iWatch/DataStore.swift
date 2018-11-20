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
    
    var context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    
    override init() {
        
        context = coreDataManager.managedObjectContext
        
    }
    
    
    func saveMovie(_ movies: Movies) {
       
        let entityDescription = NSEntityDescription.entity(forEntityName: "MoviesEntity", in: context)
        let movieToSave = MoviesEntity(entity:entityDescription!, insertInto: context)
        
        movieToSave.movieImage = movies.movieImage
        movieToSave.movieTitle = movies.movieTitle
        movieToSave.movieOverview = movies.movieOverview
        movieToSave.movieReleaseDate = movies.movieReleaseDate
        movieToSave.movieRating = movies.movieRating
        movieToSave.tagline = movies.tagline
        movieToSave.backgroundImage = movies.backgroundImage
        movieToSave.setValue(movies.movieID, forKey: "movieID")

        do {
            try context.save()
        } catch {
            abort()
        }
    }
    
    
    func fetchMovies() -> [MoviesEntity] {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "MoviesEntity", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDescription
        
        do {
            
            let result = try context.fetch(fetchRequest) as! [MoviesEntity]
            
            if result.count == 0 {
                return []
            } else {
                return result
            }
            
        } catch let error {
            
            print("Could not fetch \(error), \(String(describing: error._userInfo))")
            return []
        }
        
    }

    
    func deleteMovie(_ movie: MoviesEntity) {
        
        do {
            
            context.delete(movie)
            try context.save()
            
        } catch let error {
            
            print("Could not fetch \(error), \(String(describing: error._userInfo))")
            
        }

    }


}
