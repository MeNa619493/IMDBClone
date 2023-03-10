//
//  DBManager.swift
//  IMDBClone
//
//  Created by Mina on 04/02/2023.
//

import Foundation
import CoreData

class CoreDataManager{
    static let sharedInstance = CoreDataManager()
    
    private init(){}

    func addMovies(appDelegate: AppDelegate, movies: [Movie], completion: @escaping ((Bool) -> Void)){
        
        deleteMovies(appDelegate: appDelegate)

        appDelegate.persistentContainer.performBackgroundTask { managedContext in
            if let entity = NSEntityDescription.entity(forEntityName: "MovieDB", in: managedContext){
                
                for item in movies {
                    let movie = NSManagedObject(entity: entity, insertInto: managedContext)
                    movie.setValue(item.id, forKey: "id")
                    movie.setValue(item.rank, forKey: "rank")
                    movie.setValue(item.title, forKey: "title")
                    movie.setValue(item.fullTitle, forKey: "fullTitle")
                    movie.setValue(item.year, forKey: "year")
                    movie.setValue(item.image, forKey: "image")
                    movie.setValue(item.crew, forKey: "crew")
                    movie.setValue(item.imDBRating, forKey: "imDBRating")
                    movie.setValue(item.imDBRatingCount, forKey: "imDBRatingCount")
                }

                do {
                    try managedContext.save()
                    print("\(movies.count) movies saved in coredata")
                    completion(true)
                }catch let error as NSError {
                    print("Error in saving")
                    print(error.localizedDescription)
                    completion(false)
                }
            }
        }
    }

    func fetchMovies(appDelegate: AppDelegate, completion: @escaping ((Result<[Movie], Error>) -> Void)){

        let managedContext = appDelegate.persistentContainer.viewContext
        var fetchedList : Array<MovieDB> = [MovieDB]()
        var castedList : Array<Movie> = [Movie]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieDB")

        do{
            fetchedList = try managedContext.fetch(fetchRequest) as! Array<MovieDB>
            for item in fetchedList {
                var movie = Movie()
                movie.id = item.value(forKey: "id") as? String
                movie.rank = item.value(forKey: "rank") as? String
                movie.title = item.value(forKey: "title") as? String
                movie.fullTitle = item.value(forKey: "fullTitle") as? String
                movie.year = item.value(forKey: "year") as? String
                movie.image = item.value(forKey: "image") as? String
                movie.crew = item.value(forKey: "crew") as? String
                movie.imDBRating = item.value(forKey: "imDBRating") as? String
                movie.imDBRatingCount = item.value(forKey: "imDBRatingCount") as? String
                    
                castedList.append(movie)
            }

            print("\(castedList.count) movies retreved from coredata")
            completion(.success(castedList))
        }catch let error as NSError {
            print("Error in retreving")
            print(error.localizedDescription)
            completion(.failure(error))
        }
        
    }
    
    private func deleteMovies(appDelegate: AppDelegate){
        appDelegate.persistentContainer.performBackgroundTask { managedContext in
            do{
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDB")
                fetchRequest.returnsObjectsAsFaults = false
                
                let movies = try managedContext.fetch(fetchRequest)
                for movie in movies {
                    let movie:NSManagedObject = movie as! NSManagedObject
                    managedContext.delete(movie)
                }
                try managedContext.save()
                print("all movies deleted")
                
            } catch let error as NSError{
                print("Error in deleting")
                print(error.localizedDescription)
            }
        }
    }
}
