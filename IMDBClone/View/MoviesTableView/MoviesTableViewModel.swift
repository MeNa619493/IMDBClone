//
//  MoviesTableViewModel.swift
//  IMDBClone
//
//  Created by Mina on 03/02/2023.
//

import Foundation

class MoviesTableViewModel {
    var movies = [Movie]() {
        didSet {
            intializePaginationArray()
        }
    }
    
    var paginationMovies = [Movie]() {
        didSet {
            reloadTableViewClosure?(paginationMovies)
        }
    }
    var moviesPerPage = 10
    var limit = 0
    
    var state: State = .empty {
        didSet {
            updateLoadingStatus?()
        }
    }
        
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    let databaseManager: DatabaseService
    
    var reloadTableViewClosure: (([Movie]?)->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init(databaseManager: DatabaseService = DatabaseManager()) {
        self.databaseManager = databaseManager
    }
    
    func fetchMovies(appDelegate: AppDelegate) {
        state = .loading
        databaseManager.fetchMovies(appDelegate: appDelegate) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                if !movies.isEmpty {
                    self.state = .populated
                    self.movies = movies
                    self.limit = self.movies.count
                } else {
                    self.state = .empty
                }
            case .failure(let error):
                self.state = .error
                self.alertMessage = error.localizedDescription
            }
        }
    }
    
    func setPaginationMovies() {
        if moviesPerPage >= limit {
            return
        } else if moviesPerPage >= limit-10 {
            for i in moviesPerPage..<limit{
                paginationMovies.append(movies[i])
            }
            moviesPerPage += 10
        } else {
            for i in moviesPerPage..<moviesPerPage + 10{
                paginationMovies.append(movies[i])
            }
            moviesPerPage += 10
        }
    }
    
    private func intializePaginationArray() {
        for i in 0..<10 {
            paginationMovies.append(movies[i])
        }
    }
    
    func sortMoviesByYear() {
        state = .loading
        paginationMovies.removeAll()
        movies.sort {
            $0.year.convertStringIntoInt() > $1.year.convertStringIntoInt()
        }
        state = .populated
    }
    
    func sortMoviesByRate() {
        state = .loading
        paginationMovies.removeAll()
        movies.sort {
            $0.imDBRating.convertStringIntoDouble() > $1.imDBRating.convertStringIntoDouble()
        }
        state = .populated
    }
}
