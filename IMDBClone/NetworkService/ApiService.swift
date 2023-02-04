//
//  ApiService.swift
//  IMDBClone
//
//  Created by Mina on 02/02/2023.
//

import Foundation

protocol ApiService {
    func fetchMovies(completion: @escaping ((Result<[Movie], Error>) -> Void))
}
