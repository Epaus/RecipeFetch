//
//  NetworkManager.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 1/28/25.
//

import Foundation
import Combine
import UIKit

enum NetworkError: Error {
    case badAddress
    case invalidData
    case decodingError
    case httpError
}

enum HTTPError: LocalizedError {
    case statusCode
    
}

class NetworkManager {
    
    func fetchRecipes(url: URL?) -> AnyPublisher<[RecipeViewModel], Error>  {
        guard let url = url else {
            return Fail(error: NetworkError.badAddress).eraseToAnyPublisher()
        }
       
        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(3)
            .map(\.data)
            .decode(type: RecipeResponse.self, decoder: JSONDecoder())
            .map { $0.recipes }
            .map { recipes in
                       recipes.map { recipe in
                           RecipeViewModel(recipe: recipe)
                       }
                   }
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<[RecipeViewModel], Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

