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
    
    func fetchRecipes(url: URL?) async throws -> [Recipe] {
        
        guard let url = url else {
            return []
        }
            
        let (data, _) = try await URLSession.shared.data(from: url)
        let recipeResponse = try? JSONDecoder().decode(RecipeResponse.self, from: data)
        return recipeResponse?.recipes ?? []
        
    }

}
