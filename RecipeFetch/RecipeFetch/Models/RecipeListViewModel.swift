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
    @Published private var cancellables: Set<AnyCancellable> = []
    
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
    
   
    
    func sortRecipesByCuisine()  {
        self.recipes = recipes.sorted { $0.cuisine < $1.cuisine }
    }
    
    func sortRecipesByName() {
        self.recipes = recipes.sorted { $0.name < $1.name}
    }
    
    func sortRecipesByHasRecipe() {
        self.recipes = recipes.sorted { $0.source_url != "" && $1.source_url == ""}
    }
    
    func sortRecipesByHasVideo() {
        self.recipes =  recipes.sorted { $0.youtube_url != "" && $1.youtube_url == ""}
    }

}
import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var items: [String] = ["Apple", "Banana", "Orange", "Grape"]
    @Published var filteredItems: [String] = []

    private var cancellables: Set<AnyCancellable> = []

    init() {
        $searchTerm
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] searchTerm in
                self?.filterItems(searchTerm: searchTerm)
            }
            .store(in: &cancellables)
    }

    private func filterItems(searchTerm: String) {
        filteredItems = searchTerm.isEmpty ? items : items.filter { $0.lowercased().contains(searchTerm.lowercased()) }
    }
}
