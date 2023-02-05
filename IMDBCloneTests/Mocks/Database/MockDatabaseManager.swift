//
//  MockDatabaseManager.swift
//  IMDBCloneTests
//
//  Created by Mina on 04/02/2023.
//

import Foundation
@testable import IMDBClone

class MockDatabaseManager : DatabaseService {
    var fileName: String?
    var movieResponse: MovieResponse?
       
    init(fileName: String) {
        self.fileName = fileName
        intializeMovieArray()
    }
       
    func data(in fileName: String?, extension: String?) -> Data? {
        guard let path = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: `extension`) else {
            assertionFailure("Unable to find file name \(String(describing: fileName))")
            return nil
        }
           
        guard let data = try? Data(contentsOf: path) else {
            assertionFailure("Unable to parse data")
            return nil
        }
           
        return data
    }
    
    func intializeMovieArray() {
        guard let data = data(in: fileName, extension: "json") else {
            assertionFailure("Unable to find the file with name: RecipeResponse")
            return
        }
        do {
            movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveMovies(appDelegate: AppDelegate, movies: [Movie], completion: @escaping ((Bool) -> Void)) {
        completion(true)
    }
    
    func fetchMovies(appDelegate: AppDelegate, completion: @escaping ((Result<[Movie], Error>) -> Void)) {
        
        guard let movieResponse = movieResponse else {
            completion(.failure(DecodingError.decodingError))
            return
        }
            
        completion(.success(movieResponse.items ?? []))
        
    }
    
    enum DecodingError: Error {
        case decodingError
    }

}
