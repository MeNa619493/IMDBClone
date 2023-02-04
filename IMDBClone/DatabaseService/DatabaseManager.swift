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
        db.fetchMovies(appDelegate: appDelegate) { result in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveMovies(appDelegate: AppDelegate, movies: [Movie], completion: @escaping ((Bool) -> Void)) {
        db.addMovies(appDelegate: appDelegate, movies: movies) { isSaved in
            completion(isSaved)
        }
    }
    
}
