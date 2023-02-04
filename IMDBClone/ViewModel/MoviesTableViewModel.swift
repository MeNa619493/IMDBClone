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
            self.reloadTableViewClosure?(paginationMovies)
        }
    }
    var moviesPerPage = 10
    var limit = 0
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
        
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    let apiService: ApiService
    
    var reloadTableViewClosure: (([Movie]?)->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init(apiService: ApiService = NetworkManager()) {
        self.apiService = apiService
    }
    
    func fetchMovies() {
        state = .loading
        apiService.fetchMovies() { result in
            switch result {
            case .success(let movies):
                self.state = .populated
                self.movies = movies
                self.limit = self.movies.count
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
    
    func intializePaginationArray() {
        for i in 0..<10 {
            paginationMovies.append(movies[i])
        }
    }
    
    func sortMoviesByYear() {
        state = .loading
        paginationMovies.removeAll()
        movies.sort {
            convertStringIntoInt($0.year) > convertStringIntoInt($1.year)
        }
        state = .populated
    }
    
    func sortMoviesByRate() {
        state = .loading
        paginationMovies.removeAll()
        movies.sort {
            convertStringIntoDouble($0.imDBRating) > convertStringIntoDouble($1.imDBRating)
        }
        state = .populated
    }
    
    func convertStringIntoInt(_ string: String?) -> Int{
        guard let string = string else {
            return 0
        }
        return Int(string) ?? 0
    }
    
    func convertStringIntoDouble(_ string: String?) -> Double{
        guard let string = string else {
            return 0.0
        }
        return Double(string) ?? 0.0
    }
}
