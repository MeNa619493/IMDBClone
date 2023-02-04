//
//  SplashViewModel.swift
//  IMDBClone
//
//  Created by Mina on 04/02/2023.
//

import Foundation

class SplashViewModel {
    var state: CachedState? {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    let apiService: ApiService
    let databaseManager: DatabaseService
    
    var updateLoadingStatus: (()->())?
    
    init(apiService: ApiService = NetworkManager(), databaseManager: DatabaseService = DatabaseManager()) {
        self.apiService = apiService
        self.databaseManager = databaseManager
    }
    
    func fetchMoviesFromApi(appDelegate: AppDelegate) {
        apiService.fetchMovies() { result in
            switch result {
            case .success(let movies):
                self.saveMoviesToCoreData(appDelegate: appDelegate, movies: movies)
            case .failure(let error):
                self.state = .failed
                print(error.localizedDescription)
            }
        }
    }
    
    func saveMoviesToCoreData(appDelegate: AppDelegate, movies: [Movie]) {
        databaseManager.saveMovies(appDelegate: appDelegate, movies: movies) { isCashed in
            if isCashed {
                self.state = .success
            } else {
                self.state = .failed
            }
        }
    }
}
