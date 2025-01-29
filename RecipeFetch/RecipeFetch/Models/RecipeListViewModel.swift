//
//  RecipeListViewModel.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 1/28/25.
//

import Foundation

@MainActor
class RecipeListViewModel: ObservableObject {
    
    @Published var recipes = [RecipeViewModel]()
    
    func getRecipes() {
        
        NetworkManager().fetchRecipes( url: URLS.recipeUrl) { result in
            switch result {
            case .success(let recipes):
                DispatchQueue.main.async {
                    self.recipes = recipes.map(RecipeViewModel.init)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}
