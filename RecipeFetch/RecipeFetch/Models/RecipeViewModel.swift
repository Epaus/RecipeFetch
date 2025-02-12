//
//  RecipeViewModel.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 1/28/25.
//

import Foundation
import UIKit
import Combine

struct RecipeViewModel:  Hashable {
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    private let cache = NSCache<NSString, UIImage>()
    
    let recipe: Recipe
    
    let imageCache = NSCache<NSString, UIImage>()
    
    var recipeImage: UIImage?
    
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
    
    func downloadImage(fromURLString urlString: String, completed: @escaping(UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
    
}
