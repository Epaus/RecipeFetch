//
//  Constants.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 1/28/25.
//

import Foundation

struct URLS {
    static let recipeUrl = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
    //static let recipeUrl = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
    //static let recipeUrl = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
}

struct RecipeList {
    static var correctData: [RecipeViewModel] = {
        let recipe1 = RecipeViewModel(recipe: Recipe(cuisine: "Malaysian", name: "Apam Balik", photo_url_large: nil, photo_url_small: nil, uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", source_url: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtube_url: "https://www.youtube.com/watch?v=6R8ffRRJcrg"))
        
       let recipe2 = RecipeViewModel(recipe: Recipe(cuisine: "British", name: "Apple & Blackberry Crumble" , photo_url_large: nil, photo_url_small: nil, uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f", source_url: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble", youtube_url: nil))
        
       let recipe3 = RecipeViewModel(recipe: Recipe(cuisine: "British", name: "Apple Frangipan Tart" , photo_url_large: nil, photo_url_small: nil, uuid: "74f6d4eb-da50-4901-94d1-deae2d8af1d1", source_url: nil, youtube_url: "https://www.youtube.com/watch?v=rp8Slv4INLk"))
        
       let recipe4 = RecipeViewModel(recipe: Recipe(cuisine: "American", name: "Choc Chip Pecan Pie" , photo_url_large: nil, photo_url_small: nil, uuid: "74f6d4eb-da50-4901-94d1-deae2d8af1d1", source_url: "https://www.bbcgoodfood.com/recipes/choc-chip-pecan-pie", youtube_url: "https://www.youtube.com/watch?v=fDpoT0jvg4Y"))
       
        return [recipe1, recipe2, recipe3, recipe4]
    }()
    
    // Maybe I can use these if I ever write UITests
    static var malformedData: [RecipeViewModel] = {
        let recipe1 = RecipeViewModel(recipe: Recipe(cuisine: nil, name: "Apam Balik", photo_url_large: nil, photo_url_small: nil, uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", source_url: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtube_url: "https://www.youtube.com/watch?v=6R8ffRRJcrg"))
        
       let recipe2 = RecipeViewModel(recipe: Recipe(cuisine: "British", name: nil , photo_url_large: nil, photo_url_small: nil, uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f", source_url: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble", youtube_url: nil))
        
       let recipe3 = RecipeViewModel(recipe: Recipe(cuisine: "British", name: "Apple Frangipan Tart" , photo_url_large: nil, photo_url_small: nil, uuid: "", source_url: nil, youtube_url: "https://www.youtube.com/watch?v=rp8Slv4INLk"))
        
       let recipe4 = RecipeViewModel(recipe: Recipe(cuisine: "American", name: "Choc Chip Pecan Pie" , photo_url_large: nil, photo_url_small: nil, uuid: "74f6d4eb-da50-4901-94d1-deae2d8af1d1", source_url: "https://www.bbcgoodfood.com/recipes/choc-chip-pecan-pie", youtube_url: "https://www.youtube.com/watch?v=fDpoT0jvg4Y"))
        
        return [recipe1, recipe2, recipe3, recipe4]
    }()
    
    static var emptyData: [RecipeViewModel] = {
        return [RecipeViewModel]()
    }()
}
