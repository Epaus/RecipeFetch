//
//  Recipe.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 1/28/25.
//

import Foundation

struct RecipeResponse: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Decodable {
    let cuisine: String?
    let name: String?
    let photo_url_large: String?
    let photo_url_small: String?
    let uuid: String?
    let source_url: String?
    let youtube_url: String?
}
