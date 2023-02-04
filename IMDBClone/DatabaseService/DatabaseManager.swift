//
//  DatabaseManager.swift
//  IMDBClone
//
//  Created by Mina on 04/02/2023.
//

import Foundation

class DatabaseManager: DatabaseService {
    let db = CoreDataManager.sharedInstance

    func fetchMovies(appDelegate: AppDelegate, completion: @escaping ((Result<[Movie], Error>) -> Void)) {
        guard let movies = db.fetchMovies(appDelegate: appDelegate) else {
            completion(.failure(NSError()))
            return
        }
        completion(.success(movies))
    }
    
    func saveMovies(appDelegate: AppDelegate, movies: [Movie], completion: @escaping ((Bool) -> Void)) {
        completion(db.addMovies(appDelegate: appDelegate, movies: movies))
    }
    
}
