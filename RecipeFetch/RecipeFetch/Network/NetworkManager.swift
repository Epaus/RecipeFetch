//
//  NetworkManager.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 1/28/25.
//

import Foundation
import Combine
import UIKit



class NetworkManager {
    
    func fetchRecipes(url: URL?) -> AnyPublisher<[RecipeViewModel], Error> {
        guard let url = url else {
            return Fail(error: NetworkError.badAddress).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(3)
            .map(\.data)
            .decode(type: RecipeResponse.self, decoder: JSONDecoder())
            .map { $0.recipes }
            .tryMap { recipes in
                return try recipes.map { recipe in
                    try self.validate(recipe: recipe)
                    return RecipeViewModel(recipe: recipe)
                }
            }
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<[RecipeViewModel], Error> in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func validate(recipe: Recipe) throws {
        if (recipe.name  == nil ||
            recipe.cuisine == nil ||
            recipe.photo_url_large == nil ||
            recipe.photo_url_small == nil ||
            recipe.uuid.isEmpty) {
            
            throw RecipeError.missingField("One or more recipes are incomplete")
        }
    }
    
}

