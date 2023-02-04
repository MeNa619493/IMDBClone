//
//  NetworkManager.swift
//  IMDBClone
//
//  Created by Mina on 02/02/2023.
//

import Foundation
import Alamofire

class NetworkManager: ApiService {
    let url = "https://imdb-api.com/API/Top250Movies/k_vizmc9cr"
    
    func fetchMovies(completion: @escaping ((Result<[Movie], Error>) -> Void)) {
        guard let url = URL(string: url) else { return }
       
        AF.request(url).validate().responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(_):
                guard let moviesData = response.value else { return }
                completion(.success(moviesData.items ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
