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
    
    
    func getRecipess() async {
        
        do {
            let recipes = try await NetworkManager().fetchRecipes(url: URLS.recipeUrl)
            DispatchQueue.main.async {
                self.recipes = recipes.map(RecipeViewModel.init)
            }
        } catch {
            print(error)
        }
    }
    

}
