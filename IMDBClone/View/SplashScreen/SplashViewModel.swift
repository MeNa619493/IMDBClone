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
        apiService.fetchMovies() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let movies):
                if movies.isEmpty {
                    self.state = .failed
                } else {
                    self.saveMoviesToCoreData(appDelegate: appDelegate, movies: movies)
                }
            case .failure(let error):
                self.state = .failed
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveMoviesToCoreData(appDelegate: AppDelegate, movies: [Movie]) {
        databaseManager.saveMovies(appDelegate: appDelegate, movies: movies) { [weak self] isCashed in
            guard let self = self else { return }
            
            self.state = isCashed ? .success : .failed
        }
    }
    
}
