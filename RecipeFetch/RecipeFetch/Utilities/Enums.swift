//
//  Enums.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 2/24/25.
//

import Foundation

enum NetworkError: Error {
    case badAddress
    case invalidData
    case decodingError
    case httpError
}

enum HTTPError: LocalizedError {
    case statusCode
    
}

enum RecipeError: Error {
    case missingField(String)
}
