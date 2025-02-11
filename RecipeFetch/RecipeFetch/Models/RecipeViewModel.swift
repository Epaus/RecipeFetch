//
//  RecipeViewModel.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 1/28/25.
//

import Foundation

struct RecipeViewModel:  Hashable {
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    let recipe: Recipe
    
    var cuisine: String {
        recipe.cuisine ?? ""
    }
    
    var name: String {
        recipe.name ?? ""
    }
    
    var largePhotoString: String {
        recipe.photo_url_large ?? ""
    }
    
    var photo_url_large:  URL {
        URL(string: self.largePhotoString)!
    }
    
    var smallPhotoString: String {
        recipe.photo_url_small ?? ""
    }
    
    var photo_url_small: URL {
        URL(string: self.smallPhotoString)! //replace ! with URL to placeholder file?
    }
    
    var uuid: String {
        recipe.uuid
    }
    
    var source_url: String {
        recipe.source_url ?? ""
    }
    
    var sourceURL: URL? {
        URL(string: self.source_url) ?? nil
    }
    
    var youtube_url: String {
        recipe.youtube_url ?? ""
    }
    
    var youTubeURL: URL? {
        URL(string: self.youtube_url) ?? nil
    }
    
}
