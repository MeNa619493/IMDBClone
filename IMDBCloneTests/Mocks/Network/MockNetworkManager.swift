//
//  MockNetworkManager.swift
//  IMDBCloneTests
//
//  Created by Mina on 04/02/2023.
//

import Foundation
@testable import IMDBClone

class MockNetworkManager : ApiService {
    var fileName: String?
       
    init(fileName: String) {
        self.fileName = fileName
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
    
    func fetchMovies(completion: @escaping ((Result<[Movie], Error>) -> Void)) {
        guard let data = data(in: fileName, extension: "json") else {
            assertionFailure("Unable to find the file with name: RecipeResponse")
            return
        }
        do {
            let apiResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            completion(.success(apiResponse.items ?? []))
        } catch {
            completion(.failure(DecodingError.decodingError))
            print(error.localizedDescription)
        }
    }
    
    enum DecodingError: Error {
        case decodingError
    }

}
