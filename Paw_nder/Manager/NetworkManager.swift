//
//  NetworkManager.swift
//  Paw_nder
//
//  Created by William Yeung on 5/27/21.
//

import Foundation

class NetworkManager {
    // MARK: - Helpers
    func fetch(breedName: String, completion: @escaping (Result<[Breed], Error>) -> Void) {
        let breedName = breedName.trimmingCharacters(in: .whitespaces)
        let breedUrlString = "https://api.thedogapi.com/v1/breeds/search?q=\(breedName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let breedUrl = URL(string: breedUrlString!) {
            let request = URLRequest(url: breedUrl)
  
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error { completion(.failure(error)); return }
                
                if let data = data {
                    if let decoded = try? JSONDecoder().decode([Breed].self, from: data) {
                        completion(.success(decoded))
                    }
                }
            }.resume()
        }
    }
}
