//
//  DatabaseService.swift
//  IMDBClone
//
//  Created by Mina on 04/02/2023.
//

import Foundation

protocol DatabaseService {
    func saveMovies(appDelegate: AppDelegate, movies: [Movie], completion: @escaping ((Bool) -> Void))
    func fetchMovies(appDelegate: AppDelegate, completion: @escaping ((Result<[Movie], Error>) -> Void))
}
