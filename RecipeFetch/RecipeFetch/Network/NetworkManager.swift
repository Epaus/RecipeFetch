//
//  NetworkManager.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 1/28/25.
//

import Foundation

enum NetworkError: Error {
    case badAddress
    case invalidData
    case decodingError
}

class NetworkManager {
    
    func fetchRecipes(url: URL?, completion: @escaping (Result<[Recipe], NetworkError>) -> Void) {
        
        guard let url = url else {
            completion(.failure(.badAddress))
            return
        }
            
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
            let recipeResponse = try? JSONDecoder().decode(RecipeResponse.self, from: data)
            completion(.success(recipeResponse?.recipes ?? []))
            
        }.resume()
        
    }
    
}
